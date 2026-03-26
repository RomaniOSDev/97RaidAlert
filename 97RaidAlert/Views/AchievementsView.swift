//
//  AchievementsView.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI

struct AchievementsView: View {
    @ObservedObject var viewModel: RaidAlertViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                BlurredBackgroundView(blurRadius: 50, overlayOpacity: 0.85)
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Text("\(viewModel.totalPoints)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.raidActiveLight, Color.raidActive],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: Color.raidActive.opacity(0.4), radius: 6, x: 0, y: 2)
                            Text("Total Points")
                                .foregroundColor(.gray)
                                .font(.headline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                colors: [Color.raidBackground.opacity(0.95), Color.raidBackgroundLight.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.raidActive.opacity(0.6), Color.raidActive.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.5), radius: 12, x: 0, y: 4)
                        .shadow(color: Color.raidActive.opacity(0.15), radius: 16)
                        .padding(.horizontal)
                        
                        let achievements = viewModel.achievementsList()
                        let unlockedCount = achievements.filter { $0.isUnlocked }.count
                        
                        Text("\(unlockedCount)/\(achievements.count) Unlocked")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(achievements) { achievement in
                                AchievementCard(achievement: achievement)
                            }
                        }
                        .padding()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                .clipped()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        achievement.isUnlocked
                            ? LinearGradient(
                                colors: [Color.raidActive.opacity(0.5), Color.raidActive.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            : LinearGradient(
                                colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(
                                achievement.isUnlocked ? Color.raidActive.opacity(0.5) : Color.gray.opacity(0.2),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: achievement.isUnlocked ? Color.raidActive.opacity(0.2) : .clear, radius: 6)
                
                Image(systemName: achievement.icon)
                    .font(.title2)
                    .foregroundStyle(
                        achievement.isUnlocked
                            ? LinearGradient(
                                colors: [Color.raidActiveLight, Color.raidActive],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            : LinearGradient(colors: [.gray, .gray], startPoint: .top, endPoint: .bottom)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .foregroundColor(.white)
                    .font(.headline)
                
                Text(achievement.description)
                    .foregroundColor(.gray)
                    .font(.caption)
                
                if !achievement.isUnlocked {
                    HStack(spacing: 4) {
                        ProgressView(value: achievement.progressPercent)
                            .tint(.raidActive)
                            .frame(maxWidth: 60)
                        Text("\(achievement.progress)/\(achievement.requirement)")
                            .foregroundColor(.raidUpcoming)
                            .font(.caption2)
                    }
                } else if let date = achievement.unlockedAt {
                    Text("Unlocked")
                        .foregroundColor(.raidActive)
                        .font(.caption2)
                }
            }
            
            Spacer()
            
            if achievement.isUnlocked {
                Text("+\(achievement.points)")
                    .foregroundColor(.raidUpcoming)
                    .font(.headline)
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.raidBackground.opacity(0.95), Color.raidBackgroundLight.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [
                            (achievement.isUnlocked ? Color.raidActive : Color.gray).opacity(0.4),
                            (achievement.isUnlocked ? Color.raidActive : Color.gray).opacity(0.15)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
        .opacity(achievement.isUnlocked ? 1 : 0.85)
    }
}
