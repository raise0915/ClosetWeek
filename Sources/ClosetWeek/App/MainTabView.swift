#if canImport(SwiftUI)
import SwiftUI

struct MainTabView: View {
    let coordinator: MainTabCoordinator

    var body: some View {
        TabView(selection: Binding(get: { coordinator.selectedTab }, set: { coordinator.selectedTab = $0 })) {
            WeekRootView(coordinator: coordinator.weekCoordinator)
                .tabItem { Label("週間コーデ", systemImage: "calendar") }
                .tag(MainTab.week)

            ClosetRootView(coordinator: coordinator.closetCoordinator)
                .tabItem { Label("クローゼット", systemImage: "tshirt") }
                .tag(MainTab.closet)

            SuggestionRootView(coordinator: coordinator.suggestionCoordinator)
                .tabItem { Label("AI提案", systemImage: "sparkles") }
                .tag(MainTab.aiSuggestion)

            SettingsRootView()
                .tabItem { Label("設定", systemImage: "gear") }
                .tag(MainTab.settings)
        }
    }
}
#endif
