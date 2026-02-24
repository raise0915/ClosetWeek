import XCTest
@testable import ClosetWeek

final class WeekPlanStoreTests: XCTestCase {
    func testupsertで同一IDを更新できる() {
        let store = WeekPlanStore()
        let id = UUID()
        let initial = WeekPlan(id: id, title: "初期", days: [])
        let updated = WeekPlan(id: id, title: "更新", days: [])

        store.upsert(initial)
        store.upsert(updated)

        XCTAssertEqual(store.plan(id: id)?.title, "更新")
    }

    func testobserveでupsert通知を受ける() {
        let store = WeekPlanStore()
        let expected = expectation(description: "observer called")
        let plan = WeekPlan(title: "今週", days: [])

        _ = store.observe { updated in
            XCTAssertEqual(updated.id, plan.id)
            expected.fulfill()
        }

        store.upsert(plan)
        wait(for: [expected], timeout: 0.2)
    }
}
