//
//  GameDetailView.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI

struct GameDetailView: View {
    let game: Game
    @ObservedObject var viewModel: RaidAlertViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedEvent: GameEvent?
    @State private var showAddEvent = false
    
    private var gameEvents: [GameEvent] {
        viewModel.events
            .filter { $0.gameName == game.name && !$0.isArchived }
            .sorted { $0.startDate < $1.startDate }
    }
    
    var body: some View {
        ZStack {
            BlurredBackgroundView(blurRadius: 50, overlayOpacity: 0.85)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(gameEvents) { event in
                        Button {
                            selectedEvent = event
                        } label: {
                            EventCard(event: event)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    if gameEvents.isEmpty {
                        Text("No events for this game")
                            .foregroundColor(.gray)
                            .padding(.top, 40)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .clipped()
            .navigationTitle(game.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddEvent = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.raidActive)
                    }
                }
            }
            .navigationDestination(item: $selectedEvent) { event in
                EventDetailView(event: event, viewModel: viewModel)
            }
            .sheet(isPresented: $showAddEvent) {
                AddEventView(viewModel: viewModel, initialGameName: game.name)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
}
