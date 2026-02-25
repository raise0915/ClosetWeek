import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct HTTPRetryPolicy {
    public let maxAttempts: Int
    public let retryableStatusCodes: Set<Int>
    public let retryableErrorCodes: Set<URLError.Code>

    public init(
        maxAttempts: Int = 3,
        retryableStatusCodes: Set<Int> = Set(500...599),
        retryableErrorCodes: Set<URLError.Code> = [.timedOut, .networkConnectionLost, .notConnectedToInternet]
    ) {
        self.maxAttempts = max(1, maxAttempts)
        self.retryableStatusCodes = retryableStatusCodes
        self.retryableErrorCodes = retryableErrorCodes
    }

    func shouldRetry(statusCode: Int?, error: Error?, attempt: Int) -> Bool {
        guard attempt < maxAttempts else { return false }
        if let statusCode, retryableStatusCodes.contains(statusCode) {
            return true
        }
        guard let urlError = error as? URLError else { return false }
        return retryableErrorCodes.contains(urlError.code)
    }
}

public protocol HTTPClient {
    func execute(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func execute(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        return (data, httpResponse)
    }
}

public final class RetryingHTTPClient: HTTPClient {
    private let baseClient: HTTPClient
    private let retryPolicy: HTTPRetryPolicy

    public init(baseClient: HTTPClient, retryPolicy: HTTPRetryPolicy = .init()) {
        self.baseClient = baseClient
        self.retryPolicy = retryPolicy
    }

    public func execute(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        var attempt = 1
        while true {
            do {
                let result = try await baseClient.execute(request)
                if retryPolicy.shouldRetry(statusCode: result.1.statusCode, error: nil, attempt: attempt) {
                    attempt += 1
                    continue
                }
                return result
            } catch {
                guard retryPolicy.shouldRetry(statusCode: nil, error: error, attempt: attempt) else {
                    throw error
                }
                attempt += 1
            }
        }
    }
}

public final class WeatherAPIRepository: WeatherRepository {
    private struct Response: Decodable {
        let summary: String
    }

    private let endpoint: URL
    private let client: HTTPClient

    public init(endpoint: URL, client: HTTPClient) {
        self.endpoint = endpoint
        self.client = client
    }

    public func currentWeatherSummary() async -> String {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await client.execute(request)
            guard (200...299).contains(response.statusCode) else {
                return "天気情報の取得に失敗しました"
            }
            let decoded = try JSONDecoder().decode(Response.self, from: data)
            return decoded.summary
        } catch {
            return "天気情報の取得に失敗しました"
        }
    }
}

public final class SuggestionAPIRepository: SuggestionRepository {
    private struct Response: Decodable {
        let suggestions: [String]
    }

    private let endpoint: URL
    private let client: HTTPClient

    public init(endpoint: URL, client: HTTPClient) {
        self.endpoint = endpoint
        self.client = client
    }

    public func fetchSuggestions() async -> [Suggestion] {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await client.execute(request)
            guard (200...299).contains(response.statusCode) else {
                return []
            }
            let decoded = try JSONDecoder().decode(Response.self, from: data)
            return decoded.suggestions.map { Suggestion(title: $0) }
        } catch {
            return []
        }
    }
}
