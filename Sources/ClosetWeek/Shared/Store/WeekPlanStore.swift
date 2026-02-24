import Foundation

public final class WeekPlanStore {
    public typealias Observer = (WeekPlan) -> Void

    public private(set) var plansById: [UUID: WeekPlan]
    private var observers: [UUID: Observer] = [:]

    public init(plansById: [UUID: WeekPlan] = [:]) {
        self.plansById = plansById
    }

    public func upsert(_ plan: WeekPlan) {
        plansById[plan.id] = plan
        observers.values.forEach { $0(plan) }
    }

    public func plan(id: UUID) -> WeekPlan? {
        plansById[id]
    }

    @discardableResult
    public func observe(_ observer: @escaping Observer) -> UUID {
        let id = UUID()
        observers[id] = observer
        return id
    }

    public func removeObserver(_ id: UUID) {
        observers[id] = nil
    }
}
