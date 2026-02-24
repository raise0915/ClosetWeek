import XCTest
@testable import ClosetWeek

final class WeekDayEditorViewModelTests: XCTestCase {

    func test保存時に対象日が無ければ追加される() {
        let id = UUID()
        let baseDate = Date()
        let anotherDate = Calendar.current.date(byAdding: .day, value: 1, to: baseDate) ?? baseDate
        let original = WeekPlan(id: id, title: "今週", days: [DayOutfit(date: baseDate, summary: "既存")])
        let store = WeekPlanStore(plansById: [id: original])

        let vm = WeekDayEditorViewModel(
            weekPlanId: id,
            date: anotherDate,
            initialSummary: "追加日",
            regenerateUseCase: StubRegenerateDayOutfitUseCase(),
            store: store
        )

        vm.send(.save)

        XCTAssertEqual(store.plan(id: id)?.days.count, 2)
        XCTAssertTrue(store.plan(id: id)?.days.contains(where: { $0.summary == "追加日" }) == true)
    }

    func test再生成成功でsummary更新() {
        let store = WeekPlanStore()
        let vm = WeekDayEditorViewModel(
            weekPlanId: UUID(),
            date: Date(),
            regenerateUseCase: StubRegenerateDayOutfitUseCase(),
            store: store
        )

        vm.send(.regenerate)

        XCTAssertEqual(vm.state.status, .success)
        XCTAssertEqual(vm.state.summary, "再生成コーデ")
    }

    func test再生成失敗でerror() {
        let store = WeekPlanStore()
        let vm = WeekDayEditorViewModel(
            weekPlanId: UUID(),
            date: Date(),
            regenerateUseCase: StubRegenerateDayOutfitUseCase(shouldFail: true),
            store: store
        )

        vm.send(.regenerate)

        XCTAssertEqual(vm.state.status, .error("日別コーデ再生成に失敗しました"))
    }

    func test保存でstore更新() {
        let date = Date()
        let id = UUID()
        let original = WeekPlan(id: id, title: "今週", days: [DayOutfit(date: date, summary: "初期")])
        let store = WeekPlanStore(plansById: [id: original])

        let vm = WeekDayEditorViewModel(
            weekPlanId: id,
            date: date,
            initialSummary: "更新後",
            regenerateUseCase: StubRegenerateDayOutfitUseCase(),
            store: store
        )

        vm.send(.save)

        XCTAssertEqual(store.plan(id: id)?.days.first?.summary, "更新後")
        XCTAssertEqual(vm.state.status, .success)
    }
}
