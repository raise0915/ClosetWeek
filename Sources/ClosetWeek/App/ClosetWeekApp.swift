#if canImport(SwiftUI)
import SwiftUI

@main
struct ClosetWeekApp: App {
    @State private var coordinator = AppRuntime.makeCoordinator()

    var body: some Scene {
        WindowGroup {
            MainTabView(coordinator: coordinator.mainTabCoordinator)
        }
    }
}
#endif
