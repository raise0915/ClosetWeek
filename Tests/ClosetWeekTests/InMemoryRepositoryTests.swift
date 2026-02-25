import XCTest
@testable import ClosetWeek

final class InMemoryRepositoryTests: XCTestCase {
    func testWeekPlanRepository保存取得() throws {
        let repo = InMemoryWeekPlanRepository()
        let plan = WeekPlan(title: "今週", days: [])

        try repo.save(weekPlan: plan)

        XCTAssertEqual(repo.fetchWeeks().count, 1)
    }
}
