#if canImport(SwiftUI)
import SwiftUI

struct ClosetRootView: View {
    let coordinator: ClosetCoordinator

    var body: some View {
        NavigationStack(path: Binding(get: { coordinator.path }, set: { _ in })) {
            List {
                Text("白シャツ")
                Text("デニム")
                Button("アイテム追加") { coordinator.push(.itemEditor(itemId: nil)) }
            }
            .navigationTitle("クローゼット")
            .navigationDestination(for: ClosetRoute.self) { _ in
                Text("アイテム編集")
            }
        }
    }
}
#endif
