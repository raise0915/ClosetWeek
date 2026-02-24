#if canImport(SwiftUI)
import SwiftUI

struct SuggestionRootView: View {
    let coordinator: SuggestionCoordinator

    var body: some View {
        NavigationStack(path: Binding(get: { coordinator.path }, set: { _ in })) {
            List {
                Text("条件入力（ダミー）")
                Button("結果を見る") { coordinator.push(.suggestionDetail(suggestionId: UUID())) }
            }
            .navigationTitle("AI提案")
            .navigationDestination(for: SuggestionRoute.self) { _ in
                Text("提案詳細")
            }
        }
    }
}
#endif
