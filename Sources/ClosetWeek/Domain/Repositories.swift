import Foundation

public protocol ClosetRepository {
    func fetchItems() -> [ClosetItem]
}

public protocol WeatherRepository {
    func currentWeatherSummary() -> String
}

public protocol WeightRepository {
    func currentProfileID() -> UUID?
}

public protocol SuggestionRepository {
    func fetchSuggestions() -> [Suggestion]
}

public protocol WeekPlanRepository {
    func fetchWeeks() -> [WeekPlan]
    func save(weekPlan: WeekPlan)
}
