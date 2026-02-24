import Foundation

public final class AppCoordinator {
    public let mainTabCoordinator: MainTabCoordinator

    public init(mainTabCoordinator: MainTabCoordinator = MainTabCoordinator()) {
        self.mainTabCoordinator = mainTabCoordinator
    }
}

public final class MainTabCoordinator {
    public var selectedTab: MainTab
    public let weekCoordinator: WeekCoordinator
    public let closetCoordinator: ClosetCoordinator
    public let suggestionCoordinator: SuggestionCoordinator
    public let settingsCoordinator: SettingsCoordinator
    public let weekPlanStore: WeekPlanStore

    public init(selectedTab: MainTab = .week, weekPlanStore: WeekPlanStore = .init()) {
        self.selectedTab = selectedTab
        self.weekPlanStore = weekPlanStore
        self.weekCoordinator = WeekCoordinator(store: weekPlanStore)
        self.closetCoordinator = ClosetCoordinator()
        self.suggestionCoordinator = SuggestionCoordinator()
        self.settingsCoordinator = SettingsCoordinator()
    }
}

public final class WeekCoordinator {
    public private(set) var path: [WeekRoute] = []
    public let store: WeekPlanStore

    public init(store: WeekPlanStore) {
        self.store = store
    }

    public func push(_ route: WeekRoute) { path.append(route) }
    public func pop() { _ = path.popLast() }
}

public final class ClosetCoordinator {
    public private(set) var path: [ClosetRoute] = []
    public init() {}
    public func push(_ route: ClosetRoute) { path.append(route) }
    public func pop() { _ = path.popLast() }
}

public final class SuggestionCoordinator {
    public private(set) var path: [SuggestionRoute] = []
    public init() {}
    public func push(_ route: SuggestionRoute) { path.append(route) }
    public func pop() { _ = path.popLast() }
}

public final class SettingsCoordinator {
    public init() {}
}
