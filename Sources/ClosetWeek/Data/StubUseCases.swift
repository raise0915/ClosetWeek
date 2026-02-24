import Foundation

public enum StubError: Error {
    case forcedFailure
}

public struct StubGenerateWeekOutfitUseCase: GenerateWeekOutfitUseCase {
    public var shouldFail: Bool

    public init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }

    public func execute() -> Result<WeekPlan, Error> {
        if shouldFail { return .failure(StubError.forcedFailure) }
        let baseDate = Date()
        let days = (0..<7).map { i in
            DayOutfit(date: Calendar.current.date(byAdding: .day, value: i, to: baseDate) ?? baseDate, summary: "コーデ候補 \(i + 1)")
        }
        return .success(WeekPlan(title: "今週", days: days))
    }
}

public struct StubRegenerateDayOutfitUseCase: RegenerateDayOutfitUseCase {
    public var shouldFail: Bool

    public init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }

    public func execute(for date: Date, weekPlanId: UUID) -> Result<DayOutfit, Error> {
        if shouldFail { return .failure(StubError.forcedFailure) }
        return .success(DayOutfit(date: date, summary: "再生成コーデ"))
    }
}

public struct StubGenerateAIWeightsUseCase: GenerateAIWeightsUseCase {
    public init() {}
    public func execute() -> Result<[String : Double], Error> {
        .success(["天気": 0.4, "好み": 0.6])
    }
}

public struct StubGenerateItemSuggestionsUseCase: GenerateItemSuggestionsUseCase {
    public var shouldFail: Bool

    public init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }

    public func execute() -> Result<[Suggestion], Error> {
        shouldFail ? .failure(StubError.forcedFailure) : .success([.init(title: "新着ジャケット")])
    }
}
