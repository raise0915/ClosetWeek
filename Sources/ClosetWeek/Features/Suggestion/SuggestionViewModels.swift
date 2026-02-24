import Foundation

public final class SuggestionFlowViewModel {
    public struct State: Equatable {
        public var status: LoadingState = .idle
        public var conditions: String = ""
        public var suggestions: [Suggestion] = []
        public var selectedSuggestionID: UUID?

        public init() {}
    }

    public enum Event {
        case updateConditions(String)
        case submit
        case openDetail(UUID)
        case backFromDetail
    }

    public private(set) var state = State()
    private let useCase: GenerateItemSuggestionsUseCase

    public init(useCase: GenerateItemSuggestionsUseCase) {
        self.useCase = useCase
    }

    public func send(_ event: Event) {
        switch event {
        case .updateConditions(let text):
            state.conditions = text
        case .submit:
            state.status = .loading
            switch useCase.execute() {
            case .success(let suggestions):
                state.suggestions = suggestions
                state.status = .success
            case .failure:
                state.status = .error("AI提案の生成に失敗しました")
            }
        case .openDetail(let id):
            state.selectedSuggestionID = id
        case .backFromDetail:
            state.selectedSuggestionID = nil
        }
    }
}
