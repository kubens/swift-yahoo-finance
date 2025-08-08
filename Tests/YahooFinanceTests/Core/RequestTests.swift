import HTTPTypes
import Testing

@testable import YahooFinance

struct MockResponse: Decodable, Sendable {
  let symbol: String
}

@Suite("Request Tests")
struct RequestTests {

  @Test("initialization")
  func testRequestInit() async throws {
    let request = Request<MockResponse>(
      authority: "query1.finance.yahoo.com",
      path: "/v8/finance/chart/AAPL"
    )

    #expect(request.scheme == "https")
    #expect(request.authority == "query1.finance.yahoo.com")
    #expect(request.path == "/v8/finance/chart/AAPL")
    #expect(request.method == .get)
    #expect(request.query.isEmpty)
    #expect(request.body == nil)
  }

  @Test("with query parameters")
  func testRequestWithQuery() async throws {
    let query: URLQuery = ["interval": "1d"]
    let request = Request<MockResponse>(
      method: .post,
      authority: "query1.finance.yahoo.com",
      path: "/v8/finance/chart/AAPL",
      query: query
    )

    #expect(request.query.count == 1)
    #expect(request.query[0].name == "interval")
    #expect(request.query[0].value == "1d")
    #expect(request.method == .post)
    #expect(request.query.queryString == "interval=1d")
  }

  @Test("with multiple query parameters")
  func testRequestWithMultipleQuery() async throws {
    let query: URLQuery = ["interval": "1d", "range": "1mo"]
    let request = Request<MockResponse>(
      scheme: "http",
      authority: "query2.finance.yahoo.com",
      path: "/api/data",
      query: query
    )

    #expect(request.scheme == "http")
    #expect(request.query.queryString?.contains("interval=1d") == true)
    #expect(request.query.queryString?.contains("range=1mo") == true)
  }
}
