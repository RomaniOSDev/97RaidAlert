//
//  Achievement.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI

enum AchievementId: String, CaseIterable, Codable {
    case firstEvent = "first_event"
    case events5 = "events_5"
    case events25 = "events_25"
    case completed10 = "completed_10"
    case templates3 = "templates_3"
    case games5 = "games_5"
    case favoriteMaster = "favorite_master"
    case weeklyWarrior = "weekly_warrior"
    case raidMaster = "raid_master"
    case collector = "collector"
}

struct Achievement: Identifiable {
    let id: AchievementId
    let title: String
    let description: String
    let icon: String
    let requirement: Int
    let points: Int
    var progress: Int
    var unlockedAt: Date?
    
    var isUnlocked: Bool { unlockedAt != nil }
    var progressPercent: Double {
        min(1, Double(progress) / Double(requirement))
    }
}

struct UserStats: Codable {
    var eventsCreated: Int = 0
    var eventsCompleted: Int = 0
    var templatesUsed: Int = 0
    var gamesAdded: Int = 0
    var favoriteEventsCount: Int = 0
    var raidEventsCount: Int = 0
    var weeklyEventsCount: Int = 0
    var unlockedAchievements: [String: Date] = [:]
}
