//
//  TemplateCard.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI

struct TemplateCard: View {
    let template: EventTemplate
    
    private func formatDuration(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = Int(seconds) / 60 % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: template.type.icon)
                .foregroundColor(.raidActive)
                .font(.title2)
                .frame(width: 40)
            
            VStack(alignment: .leading) {
                Text(template.name)
                    .foregroundColor(.white)
                    .font(.headline)
                
                Text(template.gameName)
                    .foregroundColor(.gray)
                    .font(.caption)
                
                Text("Duration: \(formatDuration(template.defaultDuration))")
                    .foregroundColor(.raidUpcoming)
                    .font(.caption2)
            }
            
            Spacer()
            
            Image(systemName: "plus.circle")
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
