#if canImport(SwiftData)
import XCTest
import SwiftData
@testable import ClosetWeek

@MainActor
final class SwiftDataWeekPlanRepositoryTests: XCTestCase {
    func testsave後にfetchで同じWeekPlanが取得できる() throws {
        let schema = Schema([WeekPlanModel.self, DayOutfitModel.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let repository = SwiftDataWeekPlanRepository(context: ModelContext(container))

        let firstDay = DayOutfit(date: Date(timeIntervalSince1970: 1_700_000_000), summary: "初日")
        let secondDay = DayOutfit(date: Date(timeIntervalSince1970: 1_700_086_400), summary: "2日目")
        let plan = WeekPlan(title: "今週", days: [secondDay, firstDay])

        try repository.save(weekPlan: plan)

        let loaded = repository.fetchWeeks()
        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded.first?.id, plan.id)
        XCTAssertEqual(loaded.first?.title, "今週")
        XCTAssertEqual(loaded.first?.days.map(\.summary), ["初日", "2日目"])
    }

    func testsaveで同一IDを更新できる() throws {
        let schema = Schema([WeekPlanModel.self, DayOutfitModel.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let repository = SwiftDataWeekPlanRepository(context: ModelContext(container))

        let id = UUID()
        try repository.save(weekPlan: WeekPlan(id: id, title: "初期", days: []))
        try repository.save(weekPlan: WeekPlan(id: id, title: "更新", days: [DayOutfit(date: .now, summary: "更新日")]))

        let loaded = repository.fetchWeeks()
        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded.first?.title, "更新")
        XCTAssertEqual(loaded.first?.days.count, 1)
    }

    func testsave更新時にcreatedAtを維持しupdatedAtを更新する() throws {
        let schema = Schema([WeekPlanModel.self, DayOutfitModel.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        let context = ModelContext(container)
        let repository = SwiftDataWeekPlanRepository(context: context)

        let id = UUID()
        try repository.save(weekPlan: WeekPlan(id: id, title: "初期", days: []))

        let predicate = #Predicate<WeekPlanModel> { $0.id == id }
        let descriptor = FetchDescriptor<WeekPlanModel>(predicate: predicate)
        let initialModel = try XCTUnwrap(context.fetch(descriptor).first)
        let initialCreatedAt = initialModel.createdAt
        let initialUpdatedAt = initialModel.updatedAt

        Thread.sleep(forTimeInterval: 0.02)

        try repository.save(weekPlan: WeekPlan(id: id, title: "更新", days: []))

        let updatedModel = try XCTUnwrap(context.fetch(descriptor).first)
        XCTAssertEqual(updatedModel.createdAt, initialCreatedAt)
        XCTAssertGreaterThan(updatedModel.updatedAt, initialUpdatedAt)
    }
}
#endif
