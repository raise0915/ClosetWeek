import XCTest
@testable import ClosetWeek

final class SettingsViewModelTests: XCTestCase {
    func test地域変更が反映される() {
        let vm = SettingsViewModel()

        vm.send(.changeRegion("大阪"))

        XCTAssertEqual(vm.state.selectedRegion, "大阪")
    }

    func test通知トグルが反映される() {
        let vm = SettingsViewModel()

        vm.send(.toggleNotification(false))

        XCTAssertFalse(vm.state.enableNotification)
    }

    func test保存でステータスが設定される() {
        let vm = SettingsViewModel()

        vm.send(.save)

        XCTAssertEqual(vm.state.statusMessage, "設定を保存しました")
    }
}
