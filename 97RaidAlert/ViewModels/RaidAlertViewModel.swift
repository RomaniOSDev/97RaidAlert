//
//  RaidAlertViewModel.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import Foundation
import Combine

enum EventSortOption: String, CaseIterable {
    case date = "Date"
    case status = "Status"
    case game = "Game"
    case type = "Type"
}

class RaidAlertViewModel: ObservableObject {
    @Published var events: [GameEvent] = []
    @Published var games: [Game] = []
    @Published var templates: [EventTemplate] = []
    @Published var selectedGame: Game?
    @Published var searchText: String = ""
    @Published var sortOption: EventSortOption = .date
    @Published var sortAscending: Bool = true
    @Published var showArchived: Bool = false
    @Published var userStats: UserStats = UserStats()
    
    var filteredEvents: [GameEvent] {
        var result = events.filter { showArchived ? $0.isArchived : !$0.isArchived }
        
        if let game = selectedGame {
            result = result.filter { $0.gameName == game.name }
        }
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.gameName.localizedCaseInsensitiveContains(searchText) ||
                $0.bossName?.localizedCaseInsensitiveContains(searchText) == true ||
                $0.location?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
        
        switch sortOption {
        case .date:
            result = result.sorted { sortAscending ? $0.startDate < $1.startDate : $0.startDate > $1.startDate }
        case .status:
            result = result.sorted { sortAscending ? $0.status.rawValue < $1.status.rawValue : $0.status.rawValue > $1.status.rawValue }
        case .game:
            result = result.sorted { sortAscending ? $0.gameName < $1.gameName : $0.gameName > $1.gameName }
        case .type:
            result = result.sorted { sortAscending ? $0.type.rawValue < $1.type.rawValue : $0.type.rawValue > $1.type.rawValue }
        }
        
        return result
    }
    
    var archivedEvents: [GameEvent] {
        events.filter { $0.isArchived }.sorted { $0.endDate > $1.endDate }
    }
    
    var activeEvents: [GameEvent] {
        filteredEvents.filter { $0.status == .active }
            .sorted { $0.endDate < $1.endDate }
    }
    
    var urgentEvents: [GameEvent] {
        filteredEvents.filter { $0.status == .urgent }
            .sorted { $0.endDate < $1.endDate }
    }
    
    var upcomingEvents: [GameEvent] {
        filteredEvents.filter { $0.status == .upcoming }
            .sorted { $0.startDate < $1.startDate }
    }
    
    var expiredEvents: [GameEvent] {
        filteredEvents.filter { $0.status == .expired }
            .sorted { $0.endDate > $1.endDate }
    }
    
    var activeEventsCount: Int { activeEvents.count }
    var urgentEventsCount: Int { urgentEvents.count }
    var upcomingEventsCount: Int { upcomingEvents.count }
    var totalEventsCount: Int { events.filter { !$0.isArchived }.count }
    
    func addGame(name: String) {
        let newGame = Game(
            id: UUID(),
            name: name,
            iconName: nil,
            events: [],
            isFavorite: false
        )
        games.append(newGame)
        userStats.gamesAdded += 1
        checkAchievements()
        saveToUserDefaults()
    }
    
    func deleteGame(_ game: Game) {
        events.removeAll { $0.gameName == game.name }
        games.removeAll { $0.id == game.id }
        if selectedGame?.id == game.id {
            selectedGame = nil
        }
        saveToUserDefaults()
    }
    
    func toggleFavoriteGame(_ game: Game) {
        if let index = games.firstIndex(where: { $0.id == game.id }) {
            games[index].isFavorite.toggle()
            saveToUserDefaults()
        }
    }
    
    func addEvent(_ event: GameEvent) {
        events.append(event)
        
        if games.firstIndex(where: { $0.name == event.gameName }) == nil {
            let newGame = Game(
                id: UUID(),
                name: event.gameName,
                iconName: nil,
                events: [],
                isFavorite: false
            )
            games.append(newGame)
            userStats.gamesAdded += 1
            checkAchievements()
        }
        
        userStats.eventsCreated += 1
        checkAchievements()
        saveToUserDefaults()
    }
    
    func updateEvent(_ event: GameEvent) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
            saveToUserDefaults()
        }
    }
    
    func deleteEvent(_ event: GameEvent) {
        events.removeAll { $0.id == event.id }
        saveToUserDefaults()
    }
    
    func toggleFavoriteEvent(_ event: GameEvent) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index].isFavorite.toggle()
            saveToUserDefaults()
        }
    }
    
    func addTemplate(_ template: EventTemplate) {
        templates.append(template)
        saveToUserDefaults()
    }
    
    func deleteTemplate(_ template: EventTemplate) {
        templates.removeAll { $0.id == template.id }
        saveToUserDefaults()
    }
    
    func createEventFromTemplate(_ template: EventTemplate, startDate: Date = Date()) {
        let event = GameEvent(
            id: UUID(),
            name: template.name,
            type: template.type,
            gameName: template.gameName,
            startDate: startDate,
            endDate: startDate.addingTimeInterval(template.defaultDuration),
            location: template.defaultLocation,
            bossName: template.defaultBossName,
            rewards: template.defaultRewards,
            notes: nil,
            isFavorite: false,
            creationDate: Date()
        )
        addEvent(event)
        userStats.templatesUsed += 1
        checkAchievements()
        saveToUserDefaults()
    }
    
    func archiveEvent(_ event: GameEvent) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index].isArchived = true
            if event.status == .expired {
                userStats.eventsCompleted += 1
                checkAchievements()
            }
            saveToUserDefaults()
        }
    }
    
    func unarchiveEvent(_ event: GameEvent) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index].isArchived = false
            saveToUserDefaults()
        }
    }
    
    func duplicateEvent(_ event: GameEvent) -> GameEvent {
        let duration = event.endDate.timeIntervalSince(event.startDate)
        let newStart = Date()
        let newEvent = GameEvent(
            id: UUID(),
            name: "\(event.name) (copy)",
            type: event.type,
            gameName: event.gameName,
            startDate: newStart,
            endDate: newStart.addingTimeInterval(duration),
            location: event.location,
            bossName: event.bossName,
            rewards: event.rewards,
            notes: event.notes,
            isFavorite: false,
            creationDate: Date()
        )
        addEvent(newEvent)
        return newEvent
    }
    
    private func processRecurrence(for event: GameEvent) {
        guard event.recurrence != .none, event.status == .expired, !event.isArchived else { return }
        
        let calendar = Calendar.current
        var nextStart: Date?
        
        switch event.recurrence {
        case .none: return
        case .daily:
            nextStart = calendar.date(byAdding: .day, value: 1, to: event.startDate)
        case .weekly:
            nextStart = calendar.date(byAdding: .weekOfYear, value: 1, to: event.startDate)
        case .monthly:
            nextStart = calendar.date(byAdding: .month, value: 1, to: event.startDate)
        }
        
        guard let start = nextStart, start > Date() else { return }
        
        let duration = event.endDate.timeIntervalSince(event.startDate)
        let newEvent = GameEvent(
            id: UUID(),
            name: event.name,
            type: event.type,
            gameName: event.gameName,
            startDate: start,
            endDate: start.addingTimeInterval(duration),
            location: event.location,
            bossName: event.bossName,
            rewards: event.rewards,
            notes: event.notes,
            isFavorite: event.isFavorite,
            creationDate: Date(),
            isArchived: false,
            recurrence: event.recurrence
        )
        events.append(newEvent)
        if let idx = events.firstIndex(where: { $0.id == event.id }) {
            events[idx].isArchived = true
        }
        saveToUserDefaults()
    }
    
    func eventsForDate(_ date: Date) -> [GameEvent] {
        let calendar = Calendar.current
        return events.filter { event in
            calendar.isDate(event.startDate, inSameDayAs: date) ||
            calendar.isDate(event.endDate, inSameDayAs: date)
        }
    }
    
    private let eventsKey = "raidalert_events"
    private let gamesKey = "raidalert_games"
    private let templatesKey = "raidalert_templates"
    
    func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: eventsKey)
        }
        if let encoded = try? JSONEncoder().encode(games) {
            UserDefaults.standard.set(encoded, forKey: gamesKey)
        }
        if let encoded = try? JSONEncoder().encode(templates) {
            UserDefaults.standard.set(encoded, forKey: templatesKey)
        }
        if let encoded = try? JSONEncoder().encode(userStats) {
            UserDefaults.standard.set(encoded, forKey: "raidalert_userstats")
        }
    }
    
    func checkAchievements() {
        updateStatsFromEvents()
        
        let definitions: [(AchievementId, Int)] = [
            (.firstEvent, 1),
            (.events5, 5),
            (.events25, 25),
            (.completed10, 10),
            (.templates3, 3),
            (.games5, 5),
            (.favoriteMaster, 5),
            (.weeklyWarrior, 5),
            (.raidMaster, 10),
            (.collector, 10)
        ]
        
        for (id, req) in definitions {
            guard userStats.unlockedAchievements[id.rawValue] == nil else { continue }
            
            let progress = achievementProgress(for: id)
            if progress >= req {
                userStats.unlockedAchievements[id.rawValue] = Date()
                saveToUserDefaults()
            }
        }
    }
    
    private func updateStatsFromEvents() {
        userStats.favoriteEventsCount = events.filter { $0.isFavorite }.count
        userStats.raidEventsCount = events.filter { $0.type == .raid }.count
        userStats.weeklyEventsCount = events.filter { $0.recurrence == .weekly }.count
    }
    
    private func achievementProgress(for id: AchievementId) -> Int {
        switch id {
        case .firstEvent, .events5, .events25: return userStats.eventsCreated
        case .completed10: return userStats.eventsCompleted
        case .templates3: return userStats.templatesUsed
        case .games5: return userStats.gamesAdded
        case .favoriteMaster: return events.filter { $0.isFavorite }.count
        case .weeklyWarrior: return events.filter { $0.recurrence == .weekly }.count
        case .raidMaster: return events.filter { $0.type == .raid }.count
        case .collector: return templates.count
        }
    }
    
    func achievementsList() -> [Achievement] {
        
        let definitions: [(AchievementId, String, String, String, Int, Int)] = [
            (.firstEvent, "First Steps", "Create your first event", "star.fill", 1, 10),
            (.events5, "Event Planner", "Create 5 events", "calendar.badge.plus", 5, 25),
            (.events25, "Raid Mastermind", "Create 25 events", "crown.fill", 25, 100),
            (.completed10, "Veteran", "Complete 10 events", "checkmark.seal.fill", 10, 50),
            (.templates3, "Template User", "Use 3 templates", "doc.on.doc.fill", 3, 20),
            (.games5, "Multi-Gamer", "Add 5 games", "gamecontroller.fill", 5, 30),
            (.favoriteMaster, "Favorite Collector", "Mark 5 events as favorite", "star.circle.fill", 5, 25),
            (.weeklyWarrior, "Weekly Warrior", "Create 5 weekly recurring events", "arrow.clockwise", 5, 40),
            (.raidMaster, "Raid Expert", "Create 10 raid events", "shield.fill", 10, 50),
            (.collector, "Template Collector", "Save 10 templates", "square.stack.3d.up.fill", 10, 75)
        ]
        
        return definitions.map { id, title, desc, icon, req, points in
            Achievement(
                id: id,
                title: title,
                description: desc,
                icon: icon,
                requirement: req,
                points: points,
                progress: achievementProgress(for: id),
                unlockedAt: userStats.unlockedAchievements[id.rawValue]
            )
        }
    }
    
    var totalPoints: Int {
        achievementsList().filter { $0.isUnlocked }.reduce(0) { $0 + $1.points }
    }
    
    func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: eventsKey),
           let decoded = try? JSONDecoder().decode([GameEvent].self, from: data) {
            events = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: gamesKey),
           let decoded = try? JSONDecoder().decode([Game].self, from: data) {
            games = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: templatesKey),
           let decoded = try? JSONDecoder().decode([EventTemplate].self, from: data) {
            templates = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: "raidalert_userstats"),
           let decoded = try? JSONDecoder().decode(UserStats.self, from: data) {
            userStats = decoded
        }
        
        if events.isEmpty && games.isEmpty {
            loadDemoData()
        } else {
            for event in Array(events) where event.recurrence != .none && event.status == .expired && !event.isArchived {
                processRecurrence(for: event)
            }
        }
    }
    
    private func loadDemoData() {
        let game1 = Game(
            id: UUID(),
            name: "World of Warcraft",
            iconName: nil,
            events: [],
            isFavorite: true
        )
        
        let game2 = Game(
            id: UUID(),
            name: "Lost Ark",
            iconName: nil,
            events: [],
            isFavorite: false
        )
        
        games = [game1, game2]
        
        let now = Date()
        
        let activeEvent = GameEvent(
            id: UUID(),
            name: "Onyxia",
            type: .raid,
            gameName: "World of Warcraft",
            startDate: now.addingTimeInterval(-3600),
            endDate: now.addingTimeInterval(7200),
            location: "Onyxia's Lair",
            bossName: "Onyxia",
            rewards: "Tier 2, Onyxia Head",
            notes: "Gathering at 7:00 PM",
            isFavorite: true,
            creationDate: now
        )
        
        let urgentEvent = GameEvent(
            id: UUID(),
            name: "Valtan",
            type: .worldBoss,
            gameName: "Lost Ark",
            startDate: now.addingTimeInterval(-7200),
            endDate: now.addingTimeInterval(1800),
            location: "Beron",
            bossName: "Valtan",
            rewards: "Legendary gear",
            notes: "Need key",
            isFavorite: false,
            creationDate: now
        )
        
        let upcomingEvent = GameEvent(
            id: UUID(),
            name: "Valtan",
            type: .raid,
            gameName: "Lost Ark",
            startDate: now.addingTimeInterval(7200),
            endDate: now.addingTimeInterval(14400),
            location: "Flame",
            bossName: "Valtan",
            rewards: "Crafting materials",
            notes: nil,
            isFavorite: false,
            creationDate: now
        )
        
        events = [activeEvent, urgentEvent, upcomingEvent]
        
        let template1 = EventTemplate(
            id: UUID(),
            name: "Onyxia (weekly)",
            type: .raid,
            gameName: "World of Warcraft",
            defaultDuration: 10800,
            defaultLocation: "Onyxia's Lair",
            defaultBossName: "Onyxia",
            defaultRewards: "Tier 2"
        )
        
        let template2 = EventTemplate(
            id: UUID(),
            name: "Valtan (weekly)",
            type: .worldBoss,
            gameName: "Lost Ark",
            defaultDuration: 9000,
            defaultLocation: "Beron",
            defaultBossName: "Valtan",
            defaultRewards: "Legendary"
        )
        
        templates = [template1, template2]
    }
}
