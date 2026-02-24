import XCTest
@testable import ClosetWeek

final class SuggestionFlowViewModelTests: XCTestCase {

    func testsubmit成功で提案一覧が更新される() {
        let vm = SuggestionFlowViewModel(useCase: StubGenerateItemSuggestionsUseCase())

        vm.send(.submit)

        XCTAssertEqual(vm.state.status, .success)
        XCTAssertFalse(vm.state.suggestions.isEmpty)
    }

    func test条件入力から詳細遷移して戻っても状態保持() {
        let vm = SuggestionFlowViewModel(useCase: StubGenerateItemSuggestionsUseCase())

        vm.send(.updateConditions("寒い日"))
        vm.send(.submit)
        let id = try! XCTUnwrap(vm.state.suggestions.first?.id)
        vm.send(.openDetail(id))
        vm.send(.backFromDetail)

        XCTAssertEqual(vm.state.conditions, "寒い日")
        XCTAssertEqual(vm.state.status, .success)
        XCTAssertNil(vm.state.selectedSuggestionID)
    }

    func test生成失敗でerrorステートになる() {
        let vm = SuggestionFlowViewModel(useCase: StubGenerateItemSuggestionsUseCase(shouldFail: true))

        vm.send(.submit)

        XCTAssertEqual(vm.state.status, .error("AI提案の生成に失敗しました"))
    }
}
