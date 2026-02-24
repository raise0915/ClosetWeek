#if canImport(SwiftUI)
import SwiftUI

struct WeekRootView: View {
    let coordinator: WeekCoordinator

    @State private var currentWeek: WeekPlan?
    @State private var statusText: String = ""
    @State private var observerID: UUID?

    var body: some View {
        NavigationStack(path: Binding(get: { coordinator.path }, set: { _ in })) {
            List {
                Section("今週") {
                    if let week = currentWeek {
                        ForEach(week.days, id: \.date) { day in
                            Button(day.date.formatted(date: .abbreviated, time: .omitted) + "  " + day.summary) {
                                coordinator.push(.dayEditor(date: day.date, weekPlanId: week.id))
                            }
                        }
                    } else {
                        Text("週間コーデを生成してください")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("メニュー") {
                    Button("週間コーデを生成") { generateWeek() }
                    if let id = currentWeek?.id {
                        Button("週詳細") { coordinator.push(.weekDetail(weekPlanId: id)) }
                    }
                    Button("AI重み設定") { coordinator.push(.weightSettings(currentProfileId: nil)) }
                    Button("保存済み週") { coordinator.push(.savedWeeks) }
                }

                if !statusText.isEmpty {
                    Section("ステータス") {
                        Text(statusText)
                    }
                }
            }
            .navigationTitle("週間コーデ")
            .onAppear {
                if observerID == nil {
                    observerID = coordinator.store.observe { updated in
                        if currentWeek?.id == updated.id {
                            currentWeek = updated
                        }
                    }
                }
                if currentWeek == nil { generateWeek() }
            }
            .onDisappear {
                if let observerID {
                    coordinator.store.removeObserver(observerID)
                    self.observerID = nil
                }
            }
            .navigationDestination(for: WeekRoute.self) { route in
                switch route {
                case let .dayEditor(date, weekPlanId):
                    DayEditorView(date: date, weekPlanId: weekPlanId, store: coordinator.store)
                case let .weightSettings(currentProfileId):
                    WeightSettingsView(currentProfileId: currentProfileId)
                case .savedWeeks:
                    SavedWeeksView(coordinator: coordinator, store: coordinator.store)
                case let .weekDetail(weekPlanId):
                    WeekDetailView(weekPlanId: weekPlanId, store: coordinator.store)
                }
            }
        }
    }

    private func generateWeek() {
        switch StubGenerateWeekOutfitUseCase().execute() {
        case .success(let week):
            coordinator.store.upsert(week)
            currentWeek = week
            statusText = "週間コーデを生成しました"
        case .failure:
            statusText = "週間コーデ生成に失敗しました"
        }
    }
}

private struct DayEditorView: View {
    let date: Date
    let weekPlanId: UUID
    let store: WeekPlanStore

    @State private var summary: String = ""
    @State private var status: String = ""

    var body: some View {
        Form {
            Section("対象日") {
                Text(date.formatted(date: .abbreviated, time: .omitted))
            }
            Section("コーデ内容") {
                TextField("コーデ要約", text: $summary)
            }
            Section {
                Button("再生成") {
                    let vm = WeekDayEditorViewModel(
                        weekPlanId: weekPlanId,
                        date: date,
                        initialSummary: summary,
                        regenerateUseCase: StubRegenerateDayOutfitUseCase(),
                        store: store
                    )
                    vm.send(.regenerate)
                    summary = vm.state.summary
                    status = message(vm.state.status)
                }

                Button("保存") {
                    let vm = WeekDayEditorViewModel(
                        weekPlanId: weekPlanId,
                        date: date,
                        initialSummary: summary,
                        regenerateUseCase: StubRegenerateDayOutfitUseCase(),
                        store: store
                    )
                    vm.send(.save)
                    status = message(vm.state.status)
                }
            }

            if !status.isEmpty {
                Section("ステータス") {
                    Text(status)
                }
            }
        }
        .navigationTitle("日別編集")
        .onAppear {
            if let day = store.plan(id: weekPlanId)?.days.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
                summary = day.summary
            }
        }
    }

    private func message(_ state: LoadingState) -> String {
        switch state {
        case .idle: return ""
        case .loading: return "処理中..."
        case .success: return "保存しました"
        case let .error(msg): return msg
        }
    }
}

private struct WeightSettingsView: View {
    let currentProfileId: UUID?

    @State private var weatherWeight: Double = 0.4
    @State private var preferenceWeight: Double = 0.6

    var body: some View {
        Form {
            Section("AI重み") {
                VStack(alignment: .leading) {
                    Text("天気")
                    Slider(value: $weatherWeight, in: 0...1)
                }
                VStack(alignment: .leading) {
                    Text("好み")
                    Slider(value: $preferenceWeight, in: 0...1)
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
    let store: WeekPlanStore

    var body: some View {
        List(Array(store.plansById.keys).sorted(by: { $0.uuidString < $1.uuidString }), id: \.self) { id in
            Button("保存週: \(id.uuidString.prefix(8))") {
                coordinator.push(.weekDetail(weekPlanId: id))
            }
        }
        .navigationTitle("保存済み週一覧")
    }
}

private struct WeekDetailView: View {
    let weekPlanId: UUID
    let store: WeekPlanStore

    var body: some View {
        if let week = store.plan(id: weekPlanId) {
            List {
                Text("週ID: \(week.id.uuidString)")
                ForEach(week.days, id: \.date) { day in
                    Text(day.date.formatted(date: .abbreviated, time: .omitted) + "  " + day.summary)
                }
            }
            .navigationTitle("週詳細")
        } else {
            Text("週データがありません")
                .navigationTitle("週詳細")
        }
    }
}
#endif
