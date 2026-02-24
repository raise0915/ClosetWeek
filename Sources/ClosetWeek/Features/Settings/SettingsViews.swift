#if canImport(SwiftUI)
import SwiftUI

struct SettingsRootView: View {
    @State private var viewModel = SettingsViewModel()

    private let regions = ["東京", "大阪", "福岡", "札幌"]

    var body: some View {
        NavigationStack {
            Form {
                Section("地域") {
                    Picker(
                        "地域",
                        selection: Binding(
                            get: { viewModel.state.selectedRegion },
                            set: {
                                viewModel.send(.changeRegion($0))
                            }
                        )
                    ) {
                        ForEach(regions, id: \.self) { region in
                            Text(region).tag(region)
                        }
                    }
                    Text("現在の地域: \(viewModel.state.selectedRegion)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("通知") {
                    Toggle(
                        "朝のコーデ通知",
                        isOn: Binding(
                            get: { viewModel.state.enableNotification },
                            set: { viewModel.send(.toggleNotification($0)) }
                        )
                    )
                }

                Section("アカウント") {
                    Text("準備中")
                        .foregroundStyle(.secondary)
                }

                Section {
                    Button("設定を保存") {
                        viewModel.send(.save)
                    }
                }

                if !viewModel.state.statusMessage.isEmpty {
                    Section("ステータス") {
                        Text(viewModel.state.statusMessage)
                    }
                }
            }
            .navigationTitle("設定")
        }
    }
}
#endif
