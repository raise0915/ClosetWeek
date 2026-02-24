#if canImport(SwiftUI)
import SwiftUI

struct SettingsRootView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("地域") {
                    Text("地域設定（準備中）")
                }
                Section("アカウント") {
                    Text("準備中")
                }
            }
            .navigationTitle("設定")
        }
    }
}
#endif
