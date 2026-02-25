import XCTest
@testable import ClosetWeek

final class AppRuntimeTests: XCTestCase {
    func testAppMode_環境変数未設定の場合はDemoを返す() {
        XCTAssertEqual(AppMode.resolve(environment: [:]), .demo)
    }

    func testAppMode_Production文字列を解決できる() {
        XCTAssertEqual(AppMode.resolve(environment: ["CLOSETWEEK_ENV": "production"]), .production)
    }

    func testAppMode_未知の値はDemoにフォールバックする() {
        XCTAssertEqual(AppMode.resolve(environment: ["CLOSETWEEK_ENV": "staging"]), .demo)
    }

    func testDemoWeekSeedFactory_7日分のコーデを生成する() {
        let week = DemoWeekSeedFactory.makeSeedWeek(baseDate: Date(timeIntervalSince1970: 0), calendar: Calendar(identifier: .gregorian))

        XCTAssertEqual(week.title, "デモ週")
        XCTAssertEqual(week.days.count, 7)
        XCTAssertEqual(week.days.first?.summary, "白シャツ + デニム")
    }
}
