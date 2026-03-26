//
//  EventDetailView.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI

struct EventDetailView: View {
    let event: GameEvent
    @ObservedObject var viewModel: RaidAlertViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showEditSheet = false
    @State private var showDeleteConfirmation = false
    @State private var showArchiveConfirmation = false
    
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        return f
    }()
    
    private var currentEvent: GameEvent? {
        viewModel.events.first { $0.id == event.id }
    }
    
    var body: some View {
        let displayEvent = currentEvent ?? event
        
        ZStack {
            BlurredBackgroundView(blurRadius: 50, overlayOpacity: 0.85)
            
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: displayEvent.type.icon)
                                .font(.system(size: 60))
                                .foregroundColor(displayEvent.status.color)
                            
                            VStack(alignment: .leading) {
                                Text(displayEvent.status.rawValue)
                                    .font(.headline)
                                    .foregroundColor(displayEvent.status.color)
                                
                                Text(displayEvent.timeRemaining)
                                    .font(.title3)
                                    .foregroundColor(.white)
                            }
                            .padding(.leading)
                            
                            Spacer()
                            
                            if displayEvent.isFavorite {
                                Image(systemName: "star.fill")
                                    .font(.title)
                                    .foregroundColor(.raidUpcoming)
                            }
                        }
                        
                        Text(displayEvent.name)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(displayEvent.gameName)
                            .font(.title3)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Progress")
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text("\(Int(displayEvent.progressPercentage * 100))%")
                                .foregroundColor(displayEvent.status.color)
                                .bold()
                        }
                        
                        ProgressView(value: displayEvent.progressPercentage)
                            .tint(displayEvent.status.color)
                            .frame(height: 8)
                            .scaleEffect(y: 2)
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
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(displayEvent.status.color.opacity(0.2), lineWidth: 1)
                    )
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        TimeBox(
                            title: "Start",
                            value: dateFormatter.string(from: displayEvent.startDate),
                            icon: "play.circle"
                        )
                        
                        TimeBox(
                            title: "End",
                            value: dateFormatter.string(from: displayEvent.endDate),
                            icon: "stop.circle"
                        )
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        if let location = displayEvent.location {
                            DetailRow(
                                icon: "mappin",
                                title: "Location",
                                value: location
                            )
                        }
                        
                        if let boss = displayEvent.bossName {
                            DetailRow(
                                icon: "crown.fill",
                                title: "Boss",
                                value: boss,
                                valueColor: .raidUpcoming
                            )
                        }
                        
                        if let rewards = displayEvent.rewards {
                            DetailRow(
                                icon: "gift.fill",
                                title: "Rewards",
                                value: rewards,
                                valueColor: .raidActive
                            )
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
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.raidActive.opacity(0.2), lineWidth: 1)
                    )
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    if let notes = displayEvent.notes, !notes.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Notes")
                                .foregroundColor(.raidActive)
                                .font(.headline)
                            
                            Text(notes)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.raidBackground.opacity(0.5))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                    
                    HStack(spacing: 12) {
                        Button {
                            showEditSheet = true
                        } label: {
                            Text("Edit")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.raidActive)
                                .foregroundColor(.raidBackground)
                                .cornerRadius(10)
                        }
                        
                        Button {
                            showDeleteConfirmation = true
                        } label: {
                            Text("Delete")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.raidUrgent, lineWidth: 1)
                                )
                                .foregroundColor(.raidUrgent)
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 12) {
                        Button {
                            _ = viewModel.duplicateEvent(displayEvent)
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "doc.on.doc")
                                Text("Duplicate")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.raidUpcoming, lineWidth: 1)
                            )
                            .foregroundColor(.raidUpcoming)
                        }
                        
                        Button {
                            showArchiveConfirmation = true
                        } label: {
                            HStack {
                                Image(systemName: displayEvent.isArchived ? "arrow.uturn.backward" : "archivebox")
                                Text(displayEvent.isArchived ? "Restore" : "Archive")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .clipped()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .sheet(isPresented: $showEditSheet) {
            if let ev = currentEvent {
                AddEventView(viewModel: viewModel, editingEvent: ev)
            }
        }
        .alert("Delete Event", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                if let ev = currentEvent {
                    viewModel.deleteEvent(ev)
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this event?")
        }
        .alert(displayEvent.isArchived ? "Restore Event" : "Archive Event", isPresented: $showArchiveConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button(displayEvent.isArchived ? "Restore" : "Archive") {
                if displayEvent.isArchived {
                    viewModel.unarchiveEvent(displayEvent)
                } else {
                    viewModel.archiveEvent(displayEvent)
                }
                dismiss()
            }
        } message: {
            Text(displayEvent.isArchived ? "Move this event back to active list?" : "Move this event to archive?")
        }
    }
}
