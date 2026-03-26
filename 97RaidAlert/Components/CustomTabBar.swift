//
//  CustomTabBar.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI

private struct TabCenterKey: PreferenceKey {
    static var defaultValue: [Int: CGFloat] = [:]
    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        value.merge(nextValue()) { $1 }
    }
}

enum TabItem: Int, CaseIterable {
    case games = 0
    case home = 1
    case templates = 2
    case stats = 3
    case achievements = 4
    case settings = 5
    
    var icon: String {
        switch self {
        case .games: return "gamecontroller.fill"
        case .home: return "house.fill"
        case .templates: return "doc.on.doc.fill"
        case .stats: return "chart.bar.fill"
        case .achievements: return "trophy.fill"
        case .settings: return "gearshape.fill"
        }
    }
    
    var label: String {
        switch self {
        case .games: return "Games"
        case .home: return "Home"
        case .templates: return "Templates"
        case .stats: return "Stats"
        case .achievements: return "Achievements"
        case .settings: return "Settings"
        }
    }
    
    var isCenter: Bool { self == .home }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @State private var prevTab: Int = 1
    @State private var flowProgress: CGFloat = 1
    @State private var tabCenters: [Int: CGFloat] = [:]
    
    var body: some View {
        GeometryReader { geo in
            let fromX = tabCenters[prevTab] ?? (geo.size.width / CGFloat(TabItem.allCases.count) * (CGFloat(prevTab) + 0.5))
            let toX = tabCenters[selectedTab] ?? (geo.size.width / CGFloat(TabItem.allCases.count) * (CGFloat(selectedTab) + 0.5))
            let dropletX = fromX + (toX - fromX) * flowProgress
            
            ZStack(alignment: .topLeading) {
                HStack(spacing: 0) {
                    ForEach(TabItem.allCases, id: \.rawValue) { tab in
                        TabBarButton(
                            tab: tab,
                            isSelected: selectedTab == tab.rawValue,
                            action: {
                                prevTab = selectedTab
                                flowProgress = 0
                                selectedTab = tab.rawValue
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    flowProgress = 1
                                }
                            }
                        )
                        .frame(maxWidth: .infinity)
                        .background(
                            GeometryReader { innerGeo in
                                Color.clear.preference(
                                    key: TabCenterKey.self,
                                    value: [tab.rawValue: innerGeo.frame(in: .named("tabBar")).midX]
                                )
                            }
                        )
                    }
                }
                
                DropletView(stretch: flowProgress < 1 ? (4 * flowProgress * (1 - flowProgress)) : 0)
                    .frame(width: 18, height: 7)
                    .position(x: dropletX, y: 54)
            }
            .coordinateSpace(name: "tabBar")
            .onPreferenceChange(TabCenterKey.self) { tabCenters = $0 }
        }
        .frame(height: 70)
        .padding(.horizontal, 8)
        .background(
            LinearGradient(
                colors: [Color.raidBackgroundLight.opacity(0.95), Color.raidBackground],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(0.06), Color.clear],
                        startPoint: .top,
                        endPoint: .center
                    )
                )
                .frame(height: 1)
                .frame(maxHeight: .infinity, alignment: .top),
            alignment: .top
        )
    }
}

struct DropletView: View {
    var stretch: CGFloat = 0
    
    var body: some View {
        Ellipse()
            .fill(
                LinearGradient(
                    colors: [Color.raidActive.opacity(0.9), Color.raidActive],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .scaleEffect(x: 1 + stretch * 0.4, y: 1 - stretch * 0.2)
            .overlay(
                Ellipse()
                    .fill(Color.raidActive.opacity(0.3))
                    .blur(radius: 2)
                    .scaleEffect(1.1)
                    .scaleEffect(x: 1 + stretch * 0.4, y: 1 - stretch * 0.2)
            )
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if tab.isCenter {
                    Circle()
                        .fill(
                            isSelected
                                ? LinearGradient(
                                    colors: [Color.raidActiveLight, Color.raidActive],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                : LinearGradient(
                                    colors: [Color.raidBackgroundLight.opacity(0.9), Color.raidBackground.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                        )
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.raidActive.opacity(isSelected ? 0.6 : 0.3),
                                            Color.raidActive.opacity(isSelected ? 0.2 : 0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .frame(width: 56, height: 56)
                        .shadow(color: .black.opacity(0.4), radius: 6, x: 0, y: 3)
                        .shadow(color: isSelected ? Color.raidActive.opacity(0.5) : .clear, radius: 12, y: 2)
                }
                
                VStack(spacing: 4) {
                    Image(systemName: tab.icon)
                        .font(tab.isCenter ? .title2 : .body)
                        .foregroundColor(isSelected ? (tab.isCenter ? .raidBackground : .raidActive) : .gray)
                    
                    if !tab.isCenter {
                        Text(tab.label)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(isSelected ? .raidActive : .gray)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
        }
        .buttonStyle(.plain)
    }
}
