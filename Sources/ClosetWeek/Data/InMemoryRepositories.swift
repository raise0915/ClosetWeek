import Foundation

public final class InMemoryClosetRepository: ClosetRepository {
    private var items: [ClosetItem]

    public init(items: [ClosetItem] = [.init(name: "白シャツ"), .init(name: "デニム")]) {
        self.items = items
    }

    public func fetchItems() -> [ClosetItem] { items }
}

public final class InMemoryWeatherRepository: WeatherRepository {
    public init() {}
    public func currentWeatherSummary() -> String { "晴れ 22℃" }
}

public final class InMemoryWeightRepository: WeightRepository {
    private let profileID: UUID?

    public init(profileID: UUID? = nil) {
        self.profileID = profileID
    }

    public func currentProfileID() -> UUID? { profileID }
}

public final class InMemorySuggestionRepository: SuggestionRepository {
    private let suggestions: [Suggestion]

    public init(suggestions: [Suggestion] = [.init(title: "通勤コーデ"), .init(title: "雨の日コーデ")]) {
        self.suggestions = suggestions
    }

    public func fetchSuggestions() -> [Suggestion] { suggestions }
}

public final class InMemoryWeekPlanRepository: WeekPlanRepository {
    private var storage: [UUID: WeekPlan]

    public init(initialWeeks: [WeekPlan] = []) {
        self.storage = Dictionary(uniqueKeysWithValues: initialWeeks.map { ($0.id, $0) })
    }

    public func fetchWeeks() -> [WeekPlan] {
        Array(storage.values)
    }

    public func save(weekPlan: WeekPlan) throws {
        storage[weekPlan.id] = weekPlan
    }
}
