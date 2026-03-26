//
//  GameCard.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI

struct GameCard: View {
    let game: Game
    let activeCount: Int
    let urgentCount: Int
    let eventCount: Int
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.raidBackgroundLight, Color.raidBackground],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        (game.isFavorite ? Color.raidUpcoming : Color.raidActive).opacity(0.8),
                                        (game.isFavorite ? Color.raidUpcoming : Color.raidActive).opacity(0.3)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                    .shadow(color: (game.isFavorite ? Color.raidUpcoming : Color.raidActive).opacity(0.2), radius: 6)
                
                Image(systemName: "gamecontroller.fill")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.raidActiveLight, Color.raidActive],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(alignment: .leading) {
                Text(game.name)
                    .foregroundColor(.white)
                    .font(.headline)
                
                HStack {
                    if activeCount > 0 {
                        Label("\(activeCount)", systemImage: "play.fill")
                            .foregroundColor(.raidActive)
                            .font(.caption)
                    }
                    
                    if urgentCount > 0 {
                        Label("\(urgentCount)", systemImage: "exclamationmark.triangle.fill")
                            .foregroundColor(.raidUrgent)
                            .font(.caption)
                    }
                    
                    Text("• total \(eventCount)")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.raidActive)
        }
        .padding()
        .background(
            ZStack {
                LinearGradient(
                    colors: [Color.raidBackground.opacity(0.9), Color.raidBackgroundLight.opacity(0.5)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                LinearGradient(
                    colors: [Color.raidActive.opacity(0.05), Color.clear],
                    startPoint: .topLeading,
                    endPoint: .center
                )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [Color.raidActive.opacity(0.4), Color.raidActive.opacity(0.15)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
    }
}
