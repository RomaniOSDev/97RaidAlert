//
//  GameEvent.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI

enum EventType: String, CaseIterable, Codable {
    case raid = "Raid"
    case worldBoss = "World Boss"
    case dungeon = "Dungeon"
    case pvp = "PvP Event"
    case holiday = "Holiday Event"
    case custom = "Other"
    
    var icon: String {
        switch self {
        case .raid: return "shield.fill"
        case .worldBoss: return "crown.fill"
        case .dungeon: return "building.fill"
        case .pvp: return "figure.fencing"
        case .holiday: return "gift.fill"
        case .custom: return "star.fill"
        }
    }
}

enum EventRecurrence: String, CaseIterable, Codable {
    case none = "None"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

enum EventStatus: String, Codable {
    case upcoming = "Upcoming"
    case active = "Active"
    case urgent = "Ending Soon"
    case expired = "Completed"
    
    var color: Color {
        switch self {
        case .upcoming: return .raidUpcoming
        case .active: return .raidActive
        case .urgent: return .raidUrgent
        case .expired: return .gray
        }
    }
}

struct GameEvent: Identifiable, Codable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: GameEvent, rhs: GameEvent) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID
    var name: String
    var type: EventType
    var gameName: String
    var startDate: Date
    var endDate: Date
    var location: String?
    var bossName: String?
    var rewards: String?
    var notes: String?
    var isFavorite: Bool
    let creationDate: Date
    var isArchived: Bool
    var recurrence: EventRecurrence
    
    enum CodingKeys: String, CodingKey {
        case id, name, type, gameName, startDate, endDate, location, bossName, rewards, notes, isFavorite, creationDate
        case isArchived, recurrence
    }
    
    init(id: UUID, name: String, type: EventType, gameName: String, startDate: Date, endDate: Date,
         location: String? = nil, bossName: String? = nil, rewards: String? = nil, notes: String? = nil,
         isFavorite: Bool = false, creationDate: Date, isArchived: Bool = false, recurrence: EventRecurrence = .none) {
        self.id = id
        self.name = name
        self.type = type
        self.gameName = gameName
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.bossName = bossName
        self.rewards = rewards
        self.notes = notes
        self.isFavorite = isFavorite
        self.creationDate = creationDate
        self.isArchived = isArchived
        self.recurrence = recurrence
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(EventType.self, forKey: .type)
        gameName = try container.decode(String.self, forKey: .gameName)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        location = try container.decodeIfPresent(String.self, forKey: .location)
        bossName = try container.decodeIfPresent(String.self, forKey: .bossName)
        rewards = try container.decodeIfPresent(String.self, forKey: .rewards)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
        isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
        creationDate = try container.decode(Date.self, forKey: .creationDate)
        isArchived = try container.decodeIfPresent(Bool.self, forKey: .isArchived) ?? false
        recurrence = try container.decodeIfPresent(EventRecurrence.self, forKey: .recurrence) ?? .none
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(gameName, forKey: .gameName)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(bossName, forKey: .bossName)
        try container.encodeIfPresent(rewards, forKey: .rewards)
        try container.encodeIfPresent(notes, forKey: .notes)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(isArchived, forKey: .isArchived)
        try container.encode(recurrence, forKey: .recurrence)
    }
    
    var status: EventStatus {
        let now = Date()
        
        if now < startDate {
            return .upcoming
        } else if now > endDate {
            return .expired
        } else {
            let totalDuration = endDate.timeIntervalSince(startDate)
            let timeLeft = endDate.timeIntervalSince(now)
            let percentLeft = timeLeft / totalDuration
            
            if percentLeft < 0.3 {
                return .urgent
            } else {
                return .active
            }
        }
    }
    
    var timeRemaining: String {
        let now = Date()
        
        if now < startDate {
            let interval = startDate.timeIntervalSince(now)
            return formatTimeInterval(interval, prefix: "starts in: ")
        } else if now < endDate {
            let interval = endDate.timeIntervalSince(now)
            return formatTimeInterval(interval, prefix: "left: ")
        } else {
            return "Completed"
        }
    }
    
    private func formatTimeInterval(_ interval: TimeInterval, prefix: String) -> String {
        let hours = Int(interval) / 3600
        let minutes = Int(interval) / 60 % 60
        
        if hours > 24 {
            let days = hours / 24
            return "\(prefix)\(days)d \(hours % 24)h"
        } else if hours > 0 {
            return "\(prefix)\(hours)h \(minutes)m"
        } else {
            return "\(prefix)\(minutes)m"
        }
    }
    
    var progressPercentage: Double {
        let now = Date()
        
        if now < startDate {
            return 0
        } else if now > endDate {
            return 1
        } else {
            let totalDuration = endDate.timeIntervalSince(startDate)
            let elapsed = now.timeIntervalSince(startDate)
            return elapsed / totalDuration
        }
    }
}

struct Game: Identifiable, Codable, Hashable {
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: Game, rhs: Game) -> Bool { lhs.id == rhs.id }
    
    let id: UUID
    var name: String
    var iconName: String?
    var events: [GameEvent]
    var isFavorite: Bool
}

struct EventTemplate: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: EventType
    var gameName: String
    var defaultDuration: TimeInterval
    var defaultLocation: String?
    var defaultBossName: String?
    var defaultRewards: String?
}
