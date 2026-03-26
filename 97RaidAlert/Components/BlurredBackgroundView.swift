//
//  BlurredBackgroundView.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI

struct BlurredBackgroundView: View {
    var blurRadius: CGFloat = 40
    var overlayOpacity: Double = 0.7
    
    var body: some View {
        Image("RaidAlertBackground")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .clipped()
            .blur(radius: blurRadius)
            .overlay(
                Color.raidBackground.opacity(overlayOpacity)
            )
            .ignoresSafeArea()
    }
}
