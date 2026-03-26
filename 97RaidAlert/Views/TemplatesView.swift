//
//  TemplatesView.swift
//  97RaidAlert
//
//  Created by Xeova Nuoc on 28.02.2026.
//

import SwiftUI

struct TemplatesView: View {
    @ObservedObject var viewModel: RaidAlertViewModel
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack {
            ZStack {
                BlurredBackgroundView(blurRadius: 50, overlayOpacity: 0.85)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.templates) { template in
                            Button {
                                viewModel.createEventFromTemplate(template)
                                selectedTab = 1
                            } label: {
                                TemplateCard(template: template)
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button(role: .destructive) {
                                    viewModel.deleteTemplate(template)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        
                        if viewModel.templates.isEmpty {
                            Text("No templates. Save an event as template from the event detail screen.")
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.top, 40)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .clipped()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .navigationTitle("Templates")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}
