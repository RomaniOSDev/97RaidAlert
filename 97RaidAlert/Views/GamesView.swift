//
//  GamesView.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI

struct GamesView: View {
    @ObservedObject var viewModel: RaidAlertViewModel
    @State private var showAddGame = false
    @State private var newGameName = ""
    @State private var selectedGame: Game?
    
    var body: some View {
        NavigationStack {
            ZStack {
                BlurredBackgroundView(blurRadius: 50, overlayOpacity: 0.85)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.games) { game in
                            let eventCount = viewModel.events.filter { $0.gameName == game.name }.count
                            let activeCount = viewModel.events.filter { $0.gameName == game.name && $0.status == .active }.count
                            let urgentCount = viewModel.events.filter { $0.gameName == game.name && $0.status == .urgent }.count
                            
                            Button {
                                selectedGame = game
                            } label: {
                                GameCard(
                                    game: game,
                                    activeCount: activeCount,
                                    urgentCount: urgentCount,
                                    eventCount: eventCount
                                )
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button {
                                    viewModel.toggleFavoriteGame(game)
                                } label: {
                                    Label(game.isFavorite ? "Remove from favorites" : "Add to favorites", systemImage: "star")
                                }
                                
                                Button(role: .destructive) {
                                    viewModel.deleteGame(game)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .clipped()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .navigationTitle("My Games")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationDestination(item: $selectedGame) { game in
                GameDetailView(game: game, viewModel: viewModel)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddGame = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, Color.raidActive)
                    }
                }
            }
            .alert("Add Game", isPresented: $showAddGame) {
                TextField("Game name", text: $newGameName)
                    .textInputAutocapitalization(.words)
                Button("Cancel", role: .cancel) {
                    newGameName = ""
                }
                Button("Add") {
                    let name = newGameName.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !name.isEmpty {
                        viewModel.addGame(name: name)
                        newGameName = ""
                    }
                }
            } message: {
                Text("Enter the name of the game")
            }
        }
    }
}
