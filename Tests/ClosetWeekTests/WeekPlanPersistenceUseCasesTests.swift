import XCTest
@testable import ClosetWeek

final class WeekPlanPersistenceUseCasesTests: XCTestCase {
    func testロードUseCaseでリポジトリの週プラン一覧を取得できる() {
        let weekA = WeekPlan(title: "A", days: [])
        let weekB = WeekPlan(title: "B", days: [])
        let repository = InMemoryWeekPlanRepository(initialWeeks: [weekA, weekB])
        let useCase = LoadWeekPlansFromRepositoryUseCase(repository: repository)

        let result = useCase.execute()

        guard case .success(let loaded) = result else {
            return XCTFail("読み込みに失敗")
        }
        XCTAssertEqual(Set(loaded.map(\.id)), Set([weekA.id, weekB.id]))
    }

    func test保存UseCaseでリポジトリへ週プランを保存できる() {
        let repository = InMemoryWeekPlanRepository()
        let useCase = SaveWeekPlanToRepositoryUseCase(repository: repository)
        let plan = WeekPlan(title: "保存対象", days: [])

        let result = useCase.execute(plan)

        guard case .success = result else {
            return XCTFail("保存に失敗")
        }
        XCTAssertEqual(repository.fetchWeeks().first?.id, plan.id)
    }

    func test保存UseCaseでリポジトリエラーを返せる() {
        let repository = FailingWeekPlanRepository()
        let useCase = SaveWeekPlanToRepositoryUseCase(repository: repository)
        let plan = WeekPlan(title: "保存対象", days: [])

        let result = useCase.execute(plan)

        guard case .failure(let error) = result else {
            return XCTFail("失敗が返却されない")
        }
        XCTAssertEqual(error as? FailingWeekPlanRepository.RepositoryError, .saveFailed)
    }
}

private final class FailingWeekPlanRepository: WeekPlanRepository {
    enum RepositoryError: Error, Equatable {
        case saveFailed
    }

    func fetchWeeks() -> [WeekPlan] { [] }

    func save(weekPlan: WeekPlan) throws {
        throw RepositoryError.saveFailed
    }
}
