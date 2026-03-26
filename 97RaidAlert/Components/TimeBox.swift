//
//  TimeBox.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI

struct TimeBox: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.raidActiveLight.opacity(0.9), Color.raidActive],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text(title)
                .foregroundColor(.gray)
                .font(.caption)
            
            Text(value)
                .foregroundColor(.white)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Color.raidBackground.opacity(0.95), Color.raidBackgroundLight.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.raidActive.opacity(0.2), lineWidth: 1)
        )
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}
