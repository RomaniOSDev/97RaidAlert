//
//  RaidColors.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI

extension Color {
    static let raidBackground = Color(red: 0.055, green: 0.055, blue: 0.055) // #0e0e0e
    static let raidBackgroundLight = Color(red: 0.12, green: 0.12, blue: 0.12)
    static let raidActive = Color(red: 0.157, green: 0.659, blue: 0.036) // #28a809
    static let raidActiveLight = Color(red: 0.25, green: 0.78, blue: 0.15)
    static let raidUrgent = Color(red: 0.902, green: 0.020, blue: 0.227) // #e6053a
    static let raidUrgentLight = Color(red: 1.0, green: 0.2, blue: 0.35)
    static let raidUpcoming = Color(red: 0.820, green: 0.451, blue: 0.020) // #d17305
    static let raidUpcomingLight = Color(red: 0.95, green: 0.6, blue: 0.1)
}

extension LinearGradient {
    static let raidActiveGradient = LinearGradient(
        colors: [Color.raidActive, Color.raidActiveLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let raidUrgentGradient = LinearGradient(
        colors: [Color.raidUrgent, Color.raidUrgentLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let raidUpcomingGradient = LinearGradient(
        colors: [Color.raidUpcoming, Color.raidUpcomingLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let cardBackground = LinearGradient(
        colors: [Color.raidBackground.opacity(0.9), Color.raidBackgroundLight.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let cardGlow = LinearGradient(
        colors: [Color.white.opacity(0.05), Color.clear],
        startPoint: .top,
        endPoint: .center
    )
}
