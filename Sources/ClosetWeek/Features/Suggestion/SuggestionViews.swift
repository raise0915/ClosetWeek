#if canImport(SwiftUI)
import SwiftUI

struct SuggestionRootView: View {
    let coordinator: SuggestionCoordinator

    var body: some View {
        NavigationStack(path: Binding(get: { coordinator.path }, set: { _ in })) {
            SuggestionInputView(coordinator: coordinator)
                .navigationTitle("AI提案")
                .navigationDestination(for: SuggestionRoute.self) { route in
                    switch route {
                    case let .suggestionDetail(suggestionId):
                        SuggestionDetailView(suggestionId: suggestionId)
                    }
                }
        }
    }
}

private struct SuggestionInputView: View {
    let coordinator: SuggestionCoordinator

    @State private var viewModel = SuggestionFlowViewModel(useCase: StubGenerateItemSuggestionsUseCase())
    @State private var conditionText: String = ""
    @State private var suggestions: [Suggestion] = []
    @State private var statusMessage: String = ""

    var body: some View {
        Form {
            Section("条件入力") {
                TextField("例: 通勤 / 20℃ / 雨", text: $conditionText)
                Button("提案を生成") {
                    viewModel.send(.updateConditions(conditionText))
                    viewModel.send(.submit)
                    syncFromViewModel()
                }
            }

            if !statusMessage.isEmpty {
                Section("ステータス") {
                    Text(statusMessage)
                        .foregroundStyle(statusMessage.contains("失敗") ? .red : .secondary)
                }
            }

            Section("提案結果") {
                if suggestions.isEmpty {
                    Text("まだ提案がありません")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(suggestions) { suggestion in
                        Button(suggestion.title) {
                            viewModel.send(.openDetail(suggestion.id))
                            coordinator.push(.suggestionDetail(suggestionId: suggestion.id))
                        }
                    }
                }
            }
        }
    }

    private func syncFromViewModel() {
        suggestions = viewModel.state.suggestions
        switch viewModel.state.status {
        case .idle:
            statusMessage = ""
        case .loading:
            statusMessage = "生成中..."
        case .success:
            statusMessage = "提案を生成しました"
        case let .error(message):
            statusMessage = message
        }
    }
}

private struct SuggestionDetailView: View {
    let suggestionId: UUID

    var body: some View {
        List {
            Text("提案ID: \(suggestionId.uuidString)")
            Text("トップス: ダミー")
            Text("ボトムス: ダミー")
            Text("理由: 気温と好みに基づく（準備中）")
        }
        .navigationTitle("提案詳細")
    }
}
#endif
