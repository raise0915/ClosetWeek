#if canImport(SwiftUI)
import SwiftUI

struct ClosetRootView: View {
    let coordinator: ClosetCoordinator

    var body: some View {
        NavigationStack(path: Binding(get: { coordinator.path }, set: { _ in })) {
            ClosetListView(coordinator: coordinator)
                .navigationTitle("クローゼット")
                .navigationDestination(for: ClosetRoute.self) { route in
                    switch route {
                    case let .itemEditor(itemId):
                        ClosetItemEditorView(itemId: itemId)
                    }
                }
        }
    }
}

private struct ClosetListView: View {
    let coordinator: ClosetCoordinator

    private let itemIDs = [UUID(), UUID()]

    var body: some View {
        List {
            Section("アイテム") {
                ForEach(Array(itemIDs.enumerated()), id: \.offset) { index, id in
                    Button("アイテム\(index + 1) を編集") {
                        coordinator.push(.itemEditor(itemId: id))
                    }
                }
            }

            Section("操作") {
                Button("アイテム追加") { coordinator.push(.itemEditor(itemId: nil)) }
            }
        }
    }
}

private struct ClosetItemEditorView: View {
    let itemId: UUID?

    @State private var name = ""
    @State private var category = "トップス"

    private let categories = ["トップス", "ボトムス", "アウター", "シューズ"]

    var body: some View {
        Form {
            Section("編集対象") {
                Text(itemId?.uuidString ?? "新規アイテム")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("基本情報") {
                TextField("アイテム名", text: $name)
                Picker("カテゴリ", selection: $category) {
                    ForEach(categories, id: \.self) { c in
                        Text(c).tag(c)
                    }
                }
            }

            Section {
                Button("保存（ダミー）") {}
            }
        }
        .navigationTitle("アイテム編集")
    }
}
#endif
