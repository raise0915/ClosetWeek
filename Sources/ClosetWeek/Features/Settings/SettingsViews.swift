#if canImport(SwiftUI)
import SwiftUI

struct SettingsRootView: View {
    @State private var selectedRegion: String = "東京"
    @State private var enableNotification: Bool = true

    private let regions = ["東京", "大阪", "福岡", "札幌"]

    var body: some View {
        NavigationStack {
            Form {
                Section("地域") {
                    Picker("地域", selection: $selectedRegion) {
                        ForEach(regions, id: \.self) { region in
                            Text(region).tag(region)
                        }
                    }
                    Text("現在の地域: \(selectedRegion)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section("通知") {
                    Toggle("朝のコーデ通知", isOn: $enableNotification)
                }

                Section("アカウント") {
                    Text("準備中")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("設定")
        }
    }
}
#endif
