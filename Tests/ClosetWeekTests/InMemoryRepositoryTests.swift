import XCTest
@testable import ClosetWeek

final class InMemoryRepositoryTests: XCTestCase {
    func testWeekPlanRepository保存取得() {
        let repo = InMemoryWeekPlanRepository()
        let plan = WeekPlan(title: "今週", days: [])

        repo.save(weekPlan: plan)

        XCTAssertEqual(repo.fetchWeeks().count, 1)
    }
}
