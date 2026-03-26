//
//  StatsView.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel: RaidAlertViewModel
    
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()
    
    var body: some View {
        NavigationStack {
            ZStack {
                BlurredBackgroundView(blurRadius: 50, overlayOpacity: 0.85)
                
                ScrollView {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(viewModel.totalPoints)")
                                    .font(.title)
                                    .bold()
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color.raidActiveLight, Color.raidActive],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: Color.raidActive.opacity(0.3), radius: 2)
                                Text("Achievement points")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.raidBackground.opacity(0.95), Color.raidBackgroundLight.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.raidActive.opacity(0.3), lineWidth: 1)
                        )
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
                        .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            StatCard(
                                title: "Total events",
                                value: "\(viewModel.totalEventsCount)",
                                icon: "calendar",
                                color: .white
                            )
                            
                            StatCard(
                                title: "Active",
                                value: "\(viewModel.activeEventsCount)",
                                icon: "play.fill",
                                color: .raidActive
                            )
                            
                            StatCard(
                                title: "Urgent",
                                value: "\(viewModel.urgentEventsCount)",
                                icon: "exclamationmark.triangle.fill",
                                color: .raidUrgent
                            )
                            
                            StatCard(
                                title: "Upcoming",
                                value: "\(viewModel.upcomingEventsCount)",
                                icon: "clock",
                                color: .raidUpcoming
                            )
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("By games")
                                .foregroundColor(.raidActive)
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(viewModel.games) { game in
                                let count = viewModel.events.filter { $0.gameName == game.name }.count
                                let percentage = viewModel.totalEventsCount > 0
                                    ? Double(count) / Double(viewModel.totalEventsCount) * 100
                                    : 0.0
                                
                                HStack {
                                    Text(game.name)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text("\(count)")
                                        .foregroundColor(.gray)
                                    
                                    Text("(\(Int(percentage))%)")
                                        .foregroundColor(.raidActive)
                                        .font(.caption)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                            }
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.raidBackground.opacity(0.9), Color.raidBackgroundLight.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.raidActive.opacity(0.2), lineWidth: 1)
                        )
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 2)
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("By type")
                                .foregroundColor(.raidActive)
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(EventType.allCases, id: \.self) { type in
                                let count = viewModel.events.filter { $0.type == type }.count
                                let percentage = viewModel.totalEventsCount > 0
                                    ? Double(count) / Double(viewModel.totalEventsCount) * 100
                                    : 0.0
                                
                                if count > 0 {
                                    HStack {
                                        Image(systemName: type.icon)
                                            .foregroundColor(.raidActive)
                                            .frame(width: 24)
                                        
                                        Text(type.rawValue)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Text("\(count)")
                                            .foregroundColor(.gray)
                                        
                                        Text("(\(Int(percentage))%)")
                                            .foregroundColor(.raidActive)
                                            .font(.caption)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.raidBackground.opacity(0.9), Color.raidBackgroundLight.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.raidActive.opacity(0.2), lineWidth: 1)
                        )
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 2)
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("Upcoming days")
                                .foregroundColor(.raidActive)
                                .font(.headline)
                            
                            let calendar = Calendar.current
                            let today = Date()
                            
                            ForEach(0..<7, id: \.self) { dayOffset in
                                if let date = calendar.date(byAdding: .day, value: dayOffset, to: today) {
                                    let eventsOnDay = viewModel.eventsForDate(date)
                                    
                                    if !eventsOnDay.isEmpty {
                                        HStack {
                                            Text(dateFormatter.string(from: date))
                                                .foregroundColor(.white)
                                                .frame(width: 120, alignment: .leading)
                                            
                                            Text("\(eventsOnDay.count) events")
                                                .foregroundColor(.raidActive)
                                                .font(.caption)
                                        }
                                        .padding(.vertical, 2)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.raidBackground.opacity(0.9), Color.raidBackgroundLight.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.raidActive.opacity(0.2), lineWidth: 1)
                        )
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                .clipped()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}
