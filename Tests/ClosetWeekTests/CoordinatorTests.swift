import XCTest
@testable import ClosetWeek

final class CoordinatorTests: XCTestCase {
    func testタブ履歴保持() {
        let main = MainTabCoordinator()
        main.closetCoordinator.push(.itemEditor(itemId: nil))
        main.selectedTab = .week
        main.selectedTab = .closet

        XCTAssertEqual(main.closetCoordinator.path.count, 1)
    }

    func testWeekRoute型安全遷移() {
        let id = UUID()
        let route = WeekRoute.dayEditor(date: Date(), weekPlanId: id)

        if case let .dayEditor(_, weekPlanId) = route {
            XCTAssertEqual(weekPlanId, id)
        } else {
            XCTFail("dayEditorになっていない")
        }
    }
    func testAI提案導線のpushとpop() {
        let coordinator = SuggestionCoordinator()
        let id = UUID()

        coordinator.push(.suggestionDetail(suggestionId: id))
        XCTAssertEqual(coordinator.path.count, 1)

        coordinator.pop()
        XCTAssertTrue(coordinator.path.isEmpty)
    }

}
