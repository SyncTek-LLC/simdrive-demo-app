//
//  DashboardView.swift
//  simdrive-demo-app
//

import SwiftUI

private struct DashboardItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
}

private let dashboardItems: [DashboardItem] = [
    .init(title: "Inbox — 12 unread", icon: "envelope"),
    .init(title: "Calendar — 3 events today", icon: "calendar"),
    .init(title: "Files — 47 items", icon: "folder"),
    .init(title: "Tasks — 8 due", icon: "checklist"),
    .init(title: "Settings", icon: "gearshape")
]

struct DashboardView: View {
    let email: String
    let onLogout: () -> Void

    var body: some View {
        NavigationStack {
            List(dashboardItems) { item in
                Label(item.title, systemImage: item.icon)
            }
            .navigationTitle("Welcome, \(email)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Log Out", action: onLogout)
                        .accessibilityIdentifier("logout-button")
                }
            }
        }
    }
}

#Preview {
    DashboardView(email: "you@example.com", onLogout: {})
}
