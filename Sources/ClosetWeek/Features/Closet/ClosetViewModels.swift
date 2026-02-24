import Foundation

public final class ClosetOverviewViewModel {
    public struct State: Equatable {
        public var status: LoadingState = .idle
        public var items: [ClosetItem] = []

        public init() {}
    }

    public enum Event {
        case load
    }

    public private(set) var state = State()
    private let repository: ClosetRepository

    public init(repository: ClosetRepository) {
        self.repository = repository
    }

    public func send(_ event: Event) {
        switch event {
        case .load:
            state.status = .loading
            let items = repository.fetchItems()
            state.items = items
            state.status = .success
        }
    }
}
