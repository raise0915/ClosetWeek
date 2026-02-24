import Foundation

public enum LoadingState: Equatable {
    case idle
    case loading
    case success
    case error(String)
}

public final class WeekOverviewViewModel {
    public struct State: Equatable {
        public var status: LoadingState = .idle
        public var currentWeek: WeekPlan?

        public init() {}
    }

    public enum Event {
        case generateWeek
        case loadWeek(UUID)
        case saveDay(date: Date, summary: String)
    }

    public private(set) var state = State()

    private let generateUseCase: GenerateWeekOutfitUseCase
    private let store: WeekPlanStore
    private var observerID: UUID?

    public init(generateUseCase: GenerateWeekOutfitUseCase, store: WeekPlanStore) {
        self.generateUseCase = generateUseCase
        self.store = store
        self.observerID = store.observe { [weak self] updated in
            guard let self else { return }
            if self.state.currentWeek?.id == updated.id {
                self.state.currentWeek = updated
            }
        }
    }

    deinit {
        if let observerID {
            store.removeObserver(observerID)
        }
    }

    public func send(_ event: Event) {
        switch event {
        case .generateWeek:
            state.status = .loading
            switch generateUseCase.execute() {
            case .success(let plan):
                store.upsert(plan)
                state.currentWeek = plan
                state.status = .success
            case .failure:
                state.status = .error("週間コーデ生成に失敗しました")
            }
        case .loadWeek(let id):
            state.currentWeek = store.plan(id: id)
            state.status = state.currentWeek == nil ? .error("週プランが見つかりません") : .success
        case .saveDay(let date, let summary):
            guard var week = state.currentWeek else { return }
            if let idx = week.days.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
                week.days[idx] = DayOutfit(date: date, summary: summary)
            }
            store.upsert(week)
            state.currentWeek = week
        }
    }
}

public final class WeekDetailViewModel {
    public struct State: Equatable {
        public var status: LoadingState = .idle
        public var weekPlan: WeekPlan?

        public init() {}
    }

    public enum Event {
        case load(weekPlanId: UUID)
        case saveDay(date: Date, summary: String)
    }

    public private(set) var state = State()

    private let store: WeekPlanStore
    private var observerID: UUID?

    public init(store: WeekPlanStore) {
        self.store = store
        self.observerID = store.observe { [weak self] updated in
            guard let self else { return }
            if self.state.weekPlan?.id == updated.id {
                self.state.weekPlan = updated
            }
        }
    }

    deinit {
        if let observerID {
            store.removeObserver(observerID)
        }
    }

    public func send(_ event: Event) {
        switch event {
        case .load(let id):
            state.weekPlan = store.plan(id: id)
            state.status = state.weekPlan == nil ? .error("週プランが見つかりません") : .success
        case .saveDay(let date, let summary):
            guard var week = state.weekPlan else { return }
            if let idx = week.days.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
                week.days[idx] = DayOutfit(date: date, summary: summary)
                store.upsert(week)
                state.weekPlan = week
            }
        }
    }
}

public final class WeekDayEditorViewModel {
    public struct State: Equatable {
        public var status: LoadingState = .idle
        public var weekPlanId: UUID
        public var date: Date
        public var summary: String

        public init(weekPlanId: UUID, date: Date, summary: String = "") {
            self.weekPlanId = weekPlanId
            self.date = date
            self.summary = summary
        }
    }

    public enum Event {
        case regenerate
        case save
        case updateSummary(String)
    }

    public private(set) var state: State

    private let regenerateUseCase: RegenerateDayOutfitUseCase
    private let store: WeekPlanStore

    public init(
        weekPlanId: UUID,
        date: Date,
        initialSummary: String = "",
        regenerateUseCase: RegenerateDayOutfitUseCase,
        store: WeekPlanStore
    ) {
        self.state = State(weekPlanId: weekPlanId, date: date, summary: initialSummary)
        self.regenerateUseCase = regenerateUseCase
        self.store = store
    }

    public func send(_ event: Event) {
        switch event {
        case .updateSummary(let text):
            state.summary = text
        case .regenerate:
            state.status = .loading
            switch regenerateUseCase.execute(for: state.date, weekPlanId: state.weekPlanId) {
            case .success(let day):
                state.summary = day.summary
                state.status = .success
            case .failure:
                state.status = .error("日別コーデ再生成に失敗しました")
            }
        case .save:
            guard var plan = store.plan(id: state.weekPlanId) else {
                state.status = .error("週プランが見つかりません")
                return
            }

            if let index = plan.days.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: state.date) }) {
                plan.days[index] = DayOutfit(date: state.date, summary: state.summary)
            } else {
                plan.days.append(DayOutfit(date: state.date, summary: state.summary))
            }

            store.upsert(plan)
            state.status = .success
        }
    }
}

