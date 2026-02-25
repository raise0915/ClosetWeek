import Foundation

public protocol ClosetRepository {
    func fetchItems() -> [ClosetItem]
}

public protocol WeatherRepository {
    func currentWeatherSummary() async -> String
}

public protocol WeightRepository {
    func currentProfileID() -> UUID?
}

public protocol SuggestionRepository {
    func fetchSuggestions() async -> [Suggestion]
}

public protocol WeekPlanRepository {
    func fetchWeeks() -> [WeekPlan]
    func save(weekPlan: WeekPlan) throws
}
