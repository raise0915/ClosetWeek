#if canImport(SwiftUI)
import SwiftUI

struct WeekRootView: View {
    let coordinator: WeekCoordinator

    var body: some View {
        NavigationStack(path: Binding(get: { coordinator.path }, set: { _ in })) {
            List {
                ForEach(0..<7, id: \.self) { i in
                    Text("\(i + 1)日目 ダミーコーデ")
                }
                Button("保存済み週") { coordinator.push(.savedWeeks) }
            }
            .navigationTitle("週間コーデ")
            .navigationDestination(for: WeekRoute.self) { route in
                switch route {
                case .dayEditor(let date, _): Text("日別編集: \(date.formatted(date: .abbreviated, time: .omitted))")
                case .weightSettings: Text("AI重み設定")
                case .savedWeeks: Text("保存済み週一覧")
                case .weekDetail: Text("週詳細")
                }
            }
        }
    }
}
#endif
