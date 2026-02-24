import Foundation

public struct LoadWeekPlansFromRepositoryUseCase: LoadWeekPlansUseCase {
    private let repository: WeekPlanRepository

    public init(repository: WeekPlanRepository) {
        self.repository = repository
    }

    public func execute() -> Result<[WeekPlan], Error> {
        .success(repository.fetchWeeks())
    }
}

public struct SaveWeekPlanToRepositoryUseCase: SaveWeekPlanUseCase {
    private let repository: WeekPlanRepository

    public init(repository: WeekPlanRepository) {
        self.repository = repository
    }

    public func execute(_ weekPlan: WeekPlan) -> Result<Void, Error> {
        repository.save(weekPlan: weekPlan)
        return .success(())
    }
}
