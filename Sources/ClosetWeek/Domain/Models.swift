import Foundation

public struct DayOutfit: Equatable, Hashable {
    public var date: Date
    public var summary: String

    public init(date: Date, summary: String) {
        self.date = date
        self.summary = summary
    }
}

public struct WeekPlan: Equatable, Hashable, Identifiable {
    public var id: UUID
    public var title: String
    public var days: [DayOutfit]

    public init(id: UUID = UUID(), title: String, days: [DayOutfit]) {
        self.id = id
        self.title = title
        self.days = days
    }
}

public struct ClosetItem: Equatable, Identifiable {
    public var id: UUID
    public var name: String

    public init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

public struct Suggestion: Equatable, Identifiable {
    public var id: UUID
    public var title: String

    public init(id: UUID = UUID(), title: String) {
        self.id = id
        self.title = title
    }
}
