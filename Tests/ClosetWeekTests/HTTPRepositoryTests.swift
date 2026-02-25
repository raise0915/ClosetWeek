import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
@testable import ClosetWeek

final class HTTPRepositoryTests: XCTestCase {
    func testWeatherAPIRepository正常レスポンスを要約に変換する() {
        let endpoint = URL(string: "https://example.com/weather")!
        let client = MockHTTPClient(results: [
            .success((Data(#"{"summary":"晴れ 24℃"}"#.utf8), response(url: endpoint, statusCode: 200)))
        ])
        let repository = WeatherAPIRepository(endpoint: endpoint, client: client)

        let summary = repository.currentWeatherSummary()

        XCTAssertEqual(summary, "晴れ 24℃")
    }

    func testWeatherAPIRepository異常時は日本語エラーメッセージを返す() {
        let endpoint = URL(string: "https://example.com/weather")!
        let client = MockHTTPClient(results: [
            .success((Data(), response(url: endpoint, statusCode: 500)))
        ])
        let repository = WeatherAPIRepository(endpoint: endpoint, client: client)

        let summary = repository.currentWeatherSummary()

        XCTAssertEqual(summary, "天気情報の取得に失敗しました")
    }

    func testSuggestionAPIRepository配列レスポンスを提案モデルへ変換する() {
        let endpoint = URL(string: "https://example.com/suggestions")!
        let client = MockHTTPClient(results: [
            .success((Data(#"{"suggestions":["通勤コーデ","雨の日コーデ"]}"#.utf8), response(url: endpoint, statusCode: 200)))
        ])
        let repository = SuggestionAPIRepository(endpoint: endpoint, client: client)

        let suggestions = repository.fetchSuggestions()

        XCTAssertEqual(suggestions.map(\.title), ["通勤コーデ", "雨の日コーデ"])
    }

    func testRetryingHTTPClient500レスポンス時に再試行して成功する() throws {
        let endpoint = URL(string: "https://example.com/retry")!
        let client = MockHTTPClient(results: [
            .success((Data(), response(url: endpoint, statusCode: 500))),
            .success((Data(#"{"ok":true}"#.utf8), response(url: endpoint, statusCode: 200)))
        ])
        let retrying = RetryingHTTPClient(baseClient: client, retryPolicy: HTTPRetryPolicy(maxAttempts: 2))

        let result = try retrying.execute(URLRequest(url: endpoint))

        XCTAssertEqual(result.1.statusCode, 200)
        XCTAssertEqual(client.executeCallCount, 2)
    }
}

private final class MockHTTPClient: HTTPClient {
    private var results: [Result<(Data, HTTPURLResponse), Error>]
    private(set) var executeCallCount = 0

    init(results: [Result<(Data, HTTPURLResponse), Error>]) {
        self.results = results
    }

    func execute(_ request: URLRequest) throws -> (Data, HTTPURLResponse) {
        executeCallCount += 1
        if results.isEmpty {
            throw URLError(.badServerResponse)
        }
        return try results.removeFirst().get()
    }
}

private func response(url: URL, statusCode: Int) -> HTTPURLResponse {
    HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}
