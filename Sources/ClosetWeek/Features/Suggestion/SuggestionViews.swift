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
    @State private var conditionText: String = ""

    var body: some View {
        Form {
            Section("条件入力") {
                TextField("例: 通勤 / 20℃ / 雨", text: $conditionText)
                Button("提案を生成（ダミー）") {}
            }

            Section("提案結果") {
                ForEach(0..<3, id: \.self) { i in
                    Button("提案\(i + 1)") {
                        coordinator.push(.suggestionDetail(suggestionId: UUID()))
                    }
                }
            }
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
