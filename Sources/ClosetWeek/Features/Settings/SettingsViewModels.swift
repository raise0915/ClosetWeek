import Foundation

public final class SettingsViewModel {
    public struct State: Equatable {
        public var selectedRegion: String = "東京"
        public var enableNotification: Bool = true
        public var statusMessage: String = ""

        public init() {}
    }

    public enum Event {
        case changeRegion(String)
        case toggleNotification(Bool)
        case save
    }

    public private(set) var state = State()

    public init() {}

    public func send(_ event: Event) {
        switch event {
        case .changeRegion(let region):
            state.selectedRegion = region
        case .toggleNotification(let isOn):
            state.enableNotification = isOn
        case .save:
            state.statusMessage = "設定を保存しました"
        }
    }
}
