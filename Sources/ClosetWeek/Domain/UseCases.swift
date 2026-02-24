import Foundation

public protocol GenerateWeekOutfitUseCase {
    func execute() -> Result<WeekPlan, Error>
}

public protocol RegenerateDayOutfitUseCase {
    func execute(for date: Date, weekPlanId: UUID) -> Result<DayOutfit, Error>
}

public protocol GenerateAIWeightsUseCase {
    func execute() -> Result<[String: Double], Error>
}

public protocol GenerateItemSuggestionsUseCase {
    func execute() -> Result<[Suggestion], Error>
}
