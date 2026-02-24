import Foundation

public enum MainTab: Hashable {
    case week
    case closet
    case aiSuggestion
    case settings
}

public enum WeekRoute: Hashable {
    case dayEditor(date: Date, weekPlanId: UUID)
    case weightSettings(currentProfileId: UUID?)
    case savedWeeks
    case weekDetail(weekPlanId: UUID)
}

public enum ClosetRoute: Hashable {
    case itemEditor(itemId: UUID?)
}

public enum SuggestionRoute: Hashable {
    case suggestionDetail(suggestionId: UUID)
}
