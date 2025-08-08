import HTTPTypes
import Testing

import struct Foundation.Data

@testable import YahooFinance

@Suite("YahooFinance Tests")
struct YahooFinanceTests {

  struct MockResponse: Decodable, Sendable {
    let symbol: String
  }

  struct MockTransport: ClientTransport {
    func send(_ request: HTTPRequest, body: Data?) async throws -> (Data, HTTPResponse) {
      let response = HTTPResponse(status: .ok)
      let data = #"{"symbol": "AAPL"}"#.data(using: .utf8)!
      return (data, response)
    }
  }

  @Test("initialization")
  func testYahooFinanceInit() async throws {
    let transport = MockTransport()
    let _ = YahooFinance(transport: transport)

    // Test that it initializes without throwing
  }

  @Test("with specific UserAgent")
  func testYahooFinanceWithUserAgent() async throws {
    let transport = MockTransport()
    let _ = YahooFinance(transport: transport, userAgent: .safari)

    // Test that it initializes with specific user agent
  }

  @Test("perform request")
  func testPerformRequest() async throws {
    let transport = MockTransport()
    let yahooFinance = YahooFinance(transport: transport)

    let request = Request<MockResponse>(
      authority: "query1.finance.yahoo.com",
      path: "/v8/finance/chart/AAPL"
    )

    let response = try await yahooFinance.perform(request)
    #expect(response.symbol == "AAPL")
  }

  @Test("perform request with query parameters")
  func testPerformRequestWithQuery() async throws {
    let transport = MockTransport()
    let yahooFinance = YahooFinance(transport: transport)

    let query: URLQuery = ["interval": "1d"]
    let request = Request<MockResponse>(
      authority: "query1.finance.yahoo.com",
      path: "/v8/finance/chart/AAPL",
      query: query
    )

    let response = try await yahooFinance.perform(request)
    #expect(response.symbol == "AAPL")
  }
}
