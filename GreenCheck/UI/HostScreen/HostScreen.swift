import SwiftUI
import SwiftData

struct HostScreen: View {
    @State private var selectedTab: Int = 0
    @State private var usageInfoSheet = false
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var showWelcomeSheet: Bool = false

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)

                ManualView(selectedTab: $selectedTab)
                    .tabItem {
                        Label("Manual", systemImage: "keyboard")
                    }
                    .tag(1)

                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "clock")
                    }
                    .tag(2)

                ScannerView(selectedTab: $selectedTab)
                    .tabItem {
                        Label("Scanner", systemImage: "barcode.viewfinder")
                    }
                    .tag(3)
            }
            .tint(AppColors.primary)
            .navigationTitle(navigationTitle(for: selectedTab))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        usageInfoSheet = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
            .sheet(isPresented: $usageInfoSheet) {
                UsageSheetView()
            }
            .sheet(isPresented: $showWelcomeSheet, onDismiss: {
                hasCompletedOnboarding = true
            }) {
                WelcomeView()
            }
            .onAppear {
                if !hasCompletedOnboarding {
                    showWelcomeSheet = true
                }
            }
        }
    }

    private func navigationTitle(for tab: Int) -> String {
        switch tab {
        case 0: return "GreenCheck"
        case 1: return "Manual Entry"
        case 2: return "Scan History"
        case 3: return "Scanner"
        default: return "GreenCheck"
        }
    }
}
