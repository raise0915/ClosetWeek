#if canImport(SwiftUI)
import SwiftUI

struct WeekRootView: View {
    let coordinator: WeekCoordinator

    private let currentWeekID = UUID()

    var body: some View {
        NavigationStack(path: Binding(get: { coordinator.path }, set: { _ in })) {
            List {
                Section("今週") {
                    ForEach(0..<7, id: \.self) { i in
                        Button("\(i + 1)日目 ダミーコーデ") {
                            let date = Calendar.current.date(byAdding: .day, value: i, to: Date()) ?? Date()
                            coordinator.push(.dayEditor(date: date, weekPlanId: currentWeekID))
                        }
                    }
                }

                Section("メニュー") {
                    Button("週詳細") { coordinator.push(.weekDetail(weekPlanId: currentWeekID)) }
                    Button("AI重み設定") { coordinator.push(.weightSettings(currentProfileId: nil)) }
                    Button("保存済み週") { coordinator.push(.savedWeeks) }
                }
            }
            .navigationTitle("週間コーデ")
            .navigationDestination(for: WeekRoute.self) { route in
                switch route {
                case let .dayEditor(date, weekPlanId):
                    DayEditorView(date: date, weekPlanId: weekPlanId)
                case let .weightSettings(currentProfileId):
                    WeightSettingsView(currentProfileId: currentProfileId)
                case .savedWeeks:
                    SavedWeeksView(coordinator: coordinator)
                case let .weekDetail(weekPlanId):
                    WeekDetailView(weekPlanId: weekPlanId)
                }
            }
        }
    }
}

private struct DayEditorView: View {
    let date: Date
    let weekPlanId: UUID

    var body: some View {
        Form {
            Section("対象日") {
                Text(date.formatted(date: .abbreviated, time: .omitted))
            }
            Section("コーデスロット") {
                Text("トップス（準備中）")
                Text("ボトムス（準備中）")
                Text("アウター（準備中）")
            }
            Section {
                Button("保存（ダミー）") {}
            }
        }
        .navigationTitle("日別編集")
    }
}

private struct WeightSettingsView: View {
    let currentProfileId: UUID?

    var body: some View {
        Form {
            Section("AI重み") {
                VStack(alignment: .leading) {
                    Text("天気")
                    Slider(value: .constant(0.4), in: 0...1)
                }
                VStack(alignment: .leading) {
                    Text("好み")
                    Slider(value: .constant(0.6), in: 0...1)
                }
            }

            Section("プロファイル") {
                Text(currentProfileId?.uuidString ?? "未設定")
            }
        }
        .navigationTitle("AI重み設定")
    }
}

private struct SavedWeeksView: View {
    let coordinator: WeekCoordinator

    private let savedWeekIDs = (0..<3).map { _ in UUID() }

    var body: some View {
        List(savedWeekIDs, id: \.self) { id in
            Button("保存週: \(id.uuidString.prefix(8))") {
                coordinator.push(.weekDetail(weekPlanId: id))
            }
        }
        .navigationTitle("保存済み週一覧")
    }
}

private struct WeekDetailView: View {
    let weekPlanId: UUID

    var body: some View {
        List {
            Text("週ID: \(weekPlanId.uuidString)")
            ForEach(0..<7, id: \.self) { i in
                Text("\(i + 1)日目 詳細（ダミー）")
            }
        }
        .navigationTitle("週詳細")
    }
}
#endif
