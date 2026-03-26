//
//  SectionHeader.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(
                    LinearGradient(
                        colors: [color.opacity(0.95), color.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: color.opacity(0.2), radius: 2, x: 0, y: 1)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}
