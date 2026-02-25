import Foundation

public enum AppMode: String, Equatable {
    case demo
    case production

    private static let environmentKey = "CLOSETWEEK_ENV"

    public static func current(processInfo: ProcessInfo = .processInfo) -> AppMode {
        resolve(environment: processInfo.environment)
    }

    static func resolve(environment: [String: String]) -> AppMode {
        guard let raw = environment[environmentKey]?.trimmingCharacters(in: .whitespacesAndNewlines),
              !raw.isEmpty else {
            return .demo
        }

        return AppMode(rawValue: raw.lowercased()) ?? .demo
    }
}

public enum DemoWeekSeedFactory {
    public static func makeSeedWeek(baseDate: Date = Date(), calendar: Calendar = .current) -> WeekPlan {
        let start = calendar.startOfDay(for: baseDate)
        let summaries = [
            "白シャツ + デニム",
            "ネイビーニット + スラックス",
            "ライトアウター + ワイドパンツ",
            "セットアップ（グレー）",
            "カーディガン + テーパード",
            "パーカー + チノ",
            "シャツワンピース + スニーカー"
        ]

        let days = summaries.enumerated().map { index, summary in
            let date = calendar.date(byAdding: .day, value: index, to: start) ?? start
            return DayOutfit(date: date, summary: summary)
        }

        return WeekPlan(title: "デモ週", days: days)
    }
}

public enum AppRuntime {
    public static func makeCoordinator(processInfo: ProcessInfo = .processInfo) -> AppCoordinator {
        let store = WeekPlanStore()

        if AppMode.current(processInfo: processInfo) == .demo {
            store.upsert(DemoWeekSeedFactory.makeSeedWeek())
        }

        let coordinator = MainTabCoordinator(weekPlanStore: store)
        return AppCoordinator(mainTabCoordinator: coordinator)
    }
}
