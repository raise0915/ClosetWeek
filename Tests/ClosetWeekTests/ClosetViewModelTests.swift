import XCTest
@testable import ClosetWeek

final class ClosetViewModelTests: XCTestCase {
    func testloadでアイテムが読み込まれる() {
        let repository = InMemoryClosetRepository(items: [
            .init(name: "白シャツ"),
            .init(name: "黒パンツ")
        ])
        let vm = ClosetOverviewViewModel(repository: repository)

        vm.send(.load)

        XCTAssertEqual(vm.state.status, .success)
        XCTAssertEqual(vm.state.items.count, 2)
        XCTAssertEqual(vm.state.items.first?.name, "白シャツ")
    }
}
