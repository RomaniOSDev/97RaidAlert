//
//  ContentView.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RaidAlertViewModel()
    @State private var selectedTab = 1
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case 0:
                    GamesView(viewModel: viewModel)
                case 1:
                    DashboardView(viewModel: viewModel)
                case 2:
                    TemplatesView(viewModel: viewModel, selectedTab: $selectedTab)
                case 3:
                    StatsView(viewModel: viewModel)
                case 4:
                    AchievementsView(viewModel: viewModel)
                case 5:
                    SettingsView()
                default:
                    DashboardView(viewModel: viewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Color.clear.frame(height: 70)
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
                    .background(
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.raidBackgroundLight.opacity(0.98), Color.raidBackground],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .shadow(color: .black.opacity(0.5), radius: 20, y: -5)
                            .ignoresSafeArea()
                    )
            }
        }
        .preferredColorScheme(.dark)
        .tint(.raidActive)
        .onAppear {
            viewModel.loadFromUserDefaults()
        }
    }
}

#Preview {
    ContentView()
}
