//
//  AddEventView.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI

struct AddEventView: View {
    @ObservedObject var viewModel: RaidAlertViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var eventName = ""
    @State private var selectedGameId: UUID?
    @State private var customGame = ""
    @State private var eventType: EventType = .raid
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(3600)
    @State private var quickDuration: Double = 3600
    @State private var location = ""
    @State private var bossName = ""
    @State private var rewards = ""
    @State private var notes = ""
    @State private var isFavorite = false
    @State private var recurrence: EventRecurrence = .none
    
    private var editingEvent: GameEvent?
    private var initialGameName: String?
    
    init(viewModel: RaidAlertViewModel, editingEvent: GameEvent? = nil, initialGameName: String? = nil) {
        self.viewModel = viewModel
        self.editingEvent = editingEvent
        self.initialGameName = initialGameName
    }
    
    private var gameName: String {
        if let id = selectedGameId, let game = viewModel.games.first(where: { $0.id == id }) {
            return game.name
        }
        return customGame
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BlurredBackgroundView(blurRadius: 50, overlayOpacity: 0.9)
                
                Form {
                    Section {
                        TextField("Event name", text: $eventName)
                            .foregroundColor(.white)
                            .listRowBackground(Color.raidBackground.opacity(0.8))
                        
                        Picker("Game", selection: $selectedGameId) {
                            ForEach(viewModel.games) { game in
                                Text(game.name).tag(game.id as UUID?)
                            }
                            Text("Other").tag(nil as UUID?)
                        }
                        .foregroundColor(.white)
                        .listRowBackground(Color.raidBackground.opacity(0.8))
                        
                        if selectedGameId == nil {
                            TextField("Game name", text: $customGame)
                                .foregroundColor(.white)
                                .listRowBackground(Color.raidBackground.opacity(0.8))
                        }
                        
                        Picker("Event type", selection: $eventType) {
                            ForEach(EventType.allCases, id: \.self) { type in
                                Label(type.rawValue, systemImage: type.icon).tag(type)
                            }
                        }
                        .foregroundColor(.white)
                        .listRowBackground(Color.raidBackground.opacity(0.8))
                    } header: {
                        Text("General")
                            .foregroundColor(.raidActive)
                    }
                    
                    Section {
                        DatePicker("Start", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                            .accentColor(.raidActive)
                            .listRowBackground(Color.raidBackground.opacity(0.8))
                        
                        DatePicker("End", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                            .accentColor(.raidActive)
                            .listRowBackground(Color.raidBackground.opacity(0.8))
                        
                        Picker("Duration", selection: $quickDuration) {
                            Text("1 hour").tag(3600.0)
                            Text("2 hours").tag(7200.0)
                            Text("4 hours").tag(14400.0)
                            Text("8 hours").tag(28800.0)
                            Text("12 hours").tag(43200.0)
                            Text("24 hours").tag(86400.0)
                        }
                        .foregroundColor(.white)
                        .listRowBackground(Color.raidBackground.opacity(0.8))
                        .onChange(of: quickDuration) { newValue in
                            endDate = startDate.addingTimeInterval(newValue)
                        }
                        
                        Picker("Repeat", selection: $recurrence) {
                            ForEach(EventRecurrence.allCases, id: \.self) { r in
                                Text(r.rawValue).tag(r)
                            }
                        }
                        .foregroundColor(.white)
                        .listRowBackground(Color.raidBackground.opacity(0.8))
                    } header: {
                        Text("Time")
                            .foregroundColor(.raidActive)
                    }
                    
                    Section {
                        TextField("Location", text: $location)
                            .foregroundColor(.white)
                            .listRowBackground(Color.raidBackground.opacity(0.8))
                        
                        TextField("Boss name", text: $bossName)
                            .foregroundColor(.white)
                            .listRowBackground(Color.raidBackground.opacity(0.8))
                        
                        TextField("Rewards", text: $rewards)
                            .foregroundColor(.white)
                            .listRowBackground(Color.raidBackground.opacity(0.8))
                    } header: {
                        Text("Details")
                            .foregroundColor(.raidActive)
                    }
                    
                    Section {
                        TextEditor(text: $notes)
                            .frame(height: 100)
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                            .listRowBackground(Color.raidBackground.opacity(0.8))
                    } header: {
                        Text("Notes")
                            .foregroundColor(.raidActive)
                    }
                    
                    Section {
                        Toggle("Add to favorites", isOn: $isFavorite)
                            .tint(.raidActive)
                            .foregroundColor(.white)
                            .listRowBackground(Color.raidBackground.opacity(0.8))
                    }
                }
                .scrollContentBackground(.hidden)
                .foregroundColor(.white)
                .tint(.raidActive)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .navigationTitle(editingEvent == nil ? "New Event" : "Edit Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.raidUrgent)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveEvent()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.raidBackground)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.raidActive)
                    .cornerRadius(8)
                }
            }
            .onAppear {
                if let event = editingEvent {
                    eventName = event.name
                    selectedGameId = viewModel.games.first(where: { $0.name == event.gameName })?.id
                    if selectedGameId == nil {
                        customGame = event.gameName
                    }
                    eventType = event.type
                    startDate = event.startDate
                    endDate = event.endDate
                    location = event.location ?? ""
                    bossName = event.bossName ?? ""
                    rewards = event.rewards ?? ""
                    notes = event.notes ?? ""
                    isFavorite = event.isFavorite
                    recurrence = event.recurrence
                } else {
                    if let gameName = initialGameName {
                        if let game = viewModel.games.first(where: { $0.name == gameName }) {
                            selectedGameId = game.id
                        } else {
                            selectedGameId = nil
                            customGame = gameName
                        }
                    } else {
                        selectedGameId = viewModel.games.first?.id
                    }
                }
            }
        }
    }
    
    private func saveEvent() {
        let name = eventName.trimmingCharacters(in: .whitespacesAndNewlines)
        let game = gameName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !name.isEmpty, !game.isEmpty else { return }
        
        if let event = editingEvent {
            var updated = event
            updated.name = name
            updated.type = eventType
            updated.gameName = game
            updated.startDate = startDate
            updated.endDate = endDate
            updated.location = location.isEmpty ? nil : location
            updated.bossName = bossName.isEmpty ? nil : bossName
            updated.rewards = rewards.isEmpty ? nil : rewards
            updated.notes = notes.isEmpty ? nil : notes
            updated.isFavorite = isFavorite
            updated.recurrence = recurrence
            viewModel.updateEvent(updated)
        } else {
            let event = GameEvent(
                id: UUID(),
                name: name,
                type: eventType,
                gameName: game,
                startDate: startDate,
                endDate: endDate,
                location: location.isEmpty ? nil : location,
                bossName: bossName.isEmpty ? nil : bossName,
                rewards: rewards.isEmpty ? nil : rewards,
                notes: notes.isEmpty ? nil : notes,
                isFavorite: isFavorite,
                creationDate: Date(),
                recurrence: recurrence
            )
            viewModel.addEvent(event)
        }
        dismiss()
    }
}
