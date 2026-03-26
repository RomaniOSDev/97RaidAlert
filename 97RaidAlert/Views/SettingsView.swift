//
//  SettingsView.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                BlurredBackgroundView(blurRadius: 50, overlayOpacity: 0.85)
                
                ScrollView {
                    VStack(spacing: 12) {
                        SettingsRow(
                            icon: "star.fill",
                            title: "Rate us",
                            color: .raidUpcoming
                        ) {
                            rateApp()
                        }
                        
                        SettingsRow(
                            icon: "hand.raised.fill",
                            title: "Privacy Policy",
                            color: .raidActive
                        ) {
                            openURL("https://www.termsfeed.com/live/05649311-751c-4323-917e-e9a35062ba39")
                        }
                        
                        SettingsRow(
                            icon: "doc.text.fill",
                            title: "Terms of Use",
                            color: .raidActive
                        ) {
                            openURL("https://www.termsfeed.com/live/42f979f3-0e7c-49b3-8b87-2728b2caad93")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .clipped()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 28, alignment: .center)
                
                Text(title)
                    .foregroundColor(.white)
                    .font(.body)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.raidBackground.opacity(0.9), Color.raidBackgroundLight.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}
