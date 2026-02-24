#if canImport(SwiftUI)
import SwiftUI

@main
struct ClosetWeekApp: App {
    @State private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            MainTabView(coordinator: coordinator.mainTabCoordinator)
        }
    }
}
#endif
