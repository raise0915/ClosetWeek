import XCTest
@testable import ClosetWeek

final class WeekViewModelTests: XCTestCase {
    func test生成成功でstoreとstateが更新される() {
        let store = WeekPlanStore()
        let vm = WeekOverviewViewModel(generateUseCase: StubGenerateWeekOutfitUseCase(), store: store)

        vm.send(.generateWeek)

        XCTAssertEqual(vm.state.status, .success)
        XCTAssertEqual(store.plansById.count, 1)
    }

    func test生成失敗でerrorステートになる() {
        let store = WeekPlanStore()
        let vm = WeekOverviewViewModel(generateUseCase: StubGenerateWeekOutfitUseCase(shouldFail: true), store: store)

        vm.send(.generateWeek)

        XCTAssertEqual(vm.state.status, .error("週間コーデ生成に失敗しました"))
    }

    func test週詳細から保存すると週間側へ即時同期される() {
        let store = WeekPlanStore()
        let date = Date()
        let plan = WeekPlan(title: "今週", days: [DayOutfit(date: date, summary: "初期")])
        store.upsert(plan)

        let overview = WeekOverviewViewModel(generateUseCase: StubGenerateWeekOutfitUseCase(), store: store)
        let detail = WeekDetailViewModel(store: store)

        overview.send(.loadWeek(plan.id))
        detail.send(.load(weekPlanId: plan.id))
        detail.send(.saveDay(date: date, summary: "更新後"))

        XCTAssertEqual(store.plan(id: plan.id)?.days.first?.summary, "更新後")
        XCTAssertEqual(overview.state.currentWeek?.days.first?.summary, "更新後")
    }
}
