#if canImport(SwiftData)
import Foundation
import SwiftData

@Model
public final class WeekPlanModel {
    @Attribute(.unique) public var id: UUID
    public var title: String
    public var createdAt: Date
    public var updatedAt: Date
    public var days: [DayOutfitModel]

    public init(
        id: UUID,
        title: String,
        createdAt: Date,
        updatedAt: Date,
        days: [DayOutfitModel] = []
    ) {
        self.id = id
        self.title = title
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.days = days
    }
}

@Model
public final class DayOutfitModel {
    public var date: Date
    public var summary: String
    public var weekPlan: WeekPlanModel?

    public init(date: Date, summary: String, weekPlan: WeekPlanModel? = nil) {
        self.date = date
        self.summary = summary
        self.weekPlan = weekPlan
    }
}

public final class SwiftDataWeekPlanRepository: WeekPlanRepository {
    private let context: ModelContext

    public init(context: ModelContext) {
        self.context = context
    }

    public func fetchWeeks() -> [WeekPlan] {
        let descriptor = FetchDescriptor<WeekPlanModel>(sortBy: [SortDescriptor(\WeekPlanModel.createdAt)])
        do {
            return try context.fetch(descriptor).map { $0.toDomain() }
        } catch {
            return []
        }
    }

    public func save(weekPlan: WeekPlan) {
        let descriptor = FetchDescriptor<WeekPlanModel>(predicate: #Predicate { $0.id == weekPlan.id })
        let existing = try? context.fetch(descriptor).first

        let now = Date()
        let target = existing ?? WeekPlanModel(
            id: weekPlan.id,
            title: weekPlan.title,
            createdAt: now,
            updatedAt: now
        )

        target.title = weekPlan.title
        target.updatedAt = now
        target.days.removeAll()
        target.days = weekPlan.days.map {
            DayOutfitModel(date: $0.date, summary: $0.summary, weekPlan: target)
        }

        if existing == nil {
            context.insert(target)
        }

        try? context.save()
    }
}

private extension WeekPlanModel {
    func toDomain() -> WeekPlan {
        WeekPlan(
            id: id,
            title: title,
            days: days
                .sorted(by: { $0.date < $1.date })
                .map { DayOutfit(date: $0.date, summary: $0.summary) }
        )
    }
}
#endif
