//
//  StatCard.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [color.opacity(0.9), color],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                Text(title)
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            Text(value)
                .foregroundColor(.white)
                .font(.title2)
                .bold()
                .shadow(color: .white.opacity(0.1), radius: 1, y: 1)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                LinearGradient(
                    colors: [Color.raidBackground.opacity(0.9), Color.raidBackgroundLight.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                LinearGradient(
                    colors: [color.opacity(0.08), Color.clear],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [color.opacity(0.5), color.opacity(0.15)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
        .shadow(color: color.opacity(0.15), radius: 12, x: 0, y: 2)
    }
}
