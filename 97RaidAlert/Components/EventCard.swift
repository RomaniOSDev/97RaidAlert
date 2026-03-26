//
//  EventCard.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI

struct EventCard: View {
    let event: GameEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: event.type.icon)
                    .foregroundColor(event.status.color)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text(event.name)
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    Text(event.gameName)
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                
                Spacer()
                
                Text(event.status.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        LinearGradient(
                            colors: [event.status.color.opacity(0.3), event.status.color.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .foregroundColor(event.status.color)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(event.status.color.opacity(0.4), lineWidth: 0.5)
                    )
                
                if event.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundColor(.raidUpcoming)
                        .font(.caption)
                }
                
                if event.recurrence != .none {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.raidUpcoming)
                        .font(.caption2)
                }
            }
            
            ProgressView(value: event.progressPercentage)
                .tint(event.status.color)
            
            HStack {
                Label(event.timeRemaining, systemImage: "clock")
                    .foregroundColor(event.status.color)
                    .font(.caption)
                
                Spacer()
                
                if let location = event.location {
                    Label(location, systemImage: "mappin")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
            }
            
            if let boss = event.bossName {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundColor(.raidUpcoming)
                        .font(.caption2)
                    Text(boss)
                        .foregroundColor(.gray)
                        .font(.caption2)
                }
            }
        }
        .padding()
        .background(
            ZStack {
                LinearGradient(
                    colors: [Color.raidBackground.opacity(0.95), Color.raidBackgroundLight.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                LinearGradient(
                    colors: [event.status.color.opacity(0.06), Color.clear],
                    startPoint: .topLeading,
                    endPoint: .center
                )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [event.status.color.opacity(0.6), event.status.color.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 4)
        .shadow(color: event.status.color.opacity(0.12), radius: 8, x: 0, y: 2)
    }
}
