//
//  DashboardView.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI
import Combine

struct DashboardView: View {
    @ObservedObject var viewModel: RaidAlertViewModel
    @State private var selectedEvent: GameEvent?
    @State private var showAddEvent = false
    @State private var currentDate = Date()
    
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()
    
    var body: some View {
        NavigationStack {
            ZStack {
                BlurredBackgroundView(blurRadius: 50, overlayOpacity: 0.85)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("RaidAlert")
                                .font(.largeTitle)
                                .bold()
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.raidActiveLight, Color.raidActive],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: Color.raidActive.opacity(0.3), radius: 4, x: 0, y: 2)
                            
                            Text(dateFormatter.string(from: currentDate))
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
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
                                    icon: "calendar",
                                    color: .raidUpcoming
                                )
                                
                                StatCard(
                                    title: "Total",
                                    value: "\(viewModel.totalEventsCount)",
                                    icon: "list.bullet",
                                    color: .white
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        .frame(height: 100)
                        
                        HStack {
                            Menu {
                                ForEach(EventSortOption.allCases, id: \.self) { option in
                                    Button {
                                        viewModel.sortOption = option
                                    } label: {
                                        HStack {
                                            Text(option.rawValue)
                                            if viewModel.sortOption == option {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                                Divider()
                                Button {
                                    viewModel.sortAscending.toggle()
                                } label: {
                                    HStack {
                                        Text(viewModel.sortAscending ? "Ascending" : "Descending")
                                        Image(systemName: viewModel.sortAscending ? "arrow.up" : "arrow.down")
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "arrow.up.arrow.down.circle")
                                    Text("Sort")
                                }
                                .foregroundColor(.raidActive)
                                .font(.caption)
                            }
                            
                            Spacer()
                            
                            Button {
                                viewModel.showArchived.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: viewModel.showArchived ? "archivebox.fill" : "archivebox")
                                    Text(viewModel.showArchived ? "Archive" : "Active")
                                }
                                .foregroundColor(.raidActive)
                                .font(.caption)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                FilterChip(
                                    title: "All",
                                    isSelected: viewModel.selectedGame == nil,
                                    color: .raidActive
                                )
                                .onTapGesture {
                                    viewModel.selectedGame = nil
                                }
                                
                                ForEach(viewModel.games) { game in
                                    FilterChip(
                                        title: game.name,
                                        isSelected: viewModel.selectedGame?.id == game.id,
                                        color: .raidActive
                                    )
                                    .onTapGesture {
                                        viewModel.selectedGame = game
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        LazyVStack(spacing: 12) {
                            if !viewModel.urgentEvents.isEmpty {
                                SectionHeader(title: "🔥 URGENT!", color: .raidUrgent)
                                
                                ForEach(viewModel.urgentEvents) { event in
                                    EventCard(event: event)
                                        .onTapGesture {
                                            selectedEvent = event
                                        }
                                }
                            }
                            
                            if !viewModel.activeEvents.isEmpty {
                                SectionHeader(title: "⚔️ ACTIVE", color: .raidActive)
                                
                                ForEach(viewModel.activeEvents) { event in
                                    EventCard(event: event)
                                        .onTapGesture {
                                            selectedEvent = event
                                        }
                                }
                            }
                            
                            if !viewModel.upcomingEvents.isEmpty {
                                SectionHeader(title: "⏳ UPCOMING", color: .raidUpcoming)
                                
                                ForEach(viewModel.upcomingEvents) { event in
                                    EventCard(event: event)
                                        .onTapGesture {
                                            selectedEvent = event
                                        }
                                }
                            }
                            
                            if viewModel.showArchived && !viewModel.archivedEvents.isEmpty {
                                SectionHeader(title: "📦 ARCHIVED", color: .gray)
                                
                                ForEach(viewModel.archivedEvents) { event in
                                    EventCard(event: event)
                                        .onTapGesture {
                                            selectedEvent = event
                                        }
                                }
                            }
                            
                            if !viewModel.showArchived && !viewModel.expiredEvents.isEmpty {
                                SectionHeader(title: "✅ COMPLETED", color: .gray)
                                
                                ForEach(viewModel.expiredEvents.prefix(5)) { event in
                                    EventCard(event: event)
                                        .onTapGesture {
                                            selectedEvent = event
                                        }
                                }
                            }
                            
                            if viewModel.filteredEvents.isEmpty {
                                Text("No events")
                                    .foregroundColor(.gray)
                                    .padding(.top, 40)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 80)
                }
                .clipped()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .searchable(text: $viewModel.searchText, prompt: "Search events")
            .navigationDestination(item: $selectedEvent) { event in
                EventDetailView(event: event, viewModel: viewModel)
            }
            .sheet(isPresented: $showAddEvent) {
                AddEventView(viewModel: viewModel)
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    showAddEvent = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.raidActiveLight, Color.raidActive],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)
                            .shadow(color: Color.raidActive.opacity(0.5), radius: 12, x: 0, y: 4)
                            .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
                        
                        Image(systemName: "plus")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.raidBackground)
                    }
                }
                .padding(24)
            }
            .onAppear {
                currentDate = Date()
            }
            .onReceive(Timer.publish(every: 60, on: .main, in: .common).autoconnect()) { _ in
                currentDate = Date()
            }
        }
    }
}
