import Testing

@testable import YahooFinance

@Suite("URLQuery Tests")
struct URLQueryTests {

  @Test("element initialization")
  func testElementInit() async throws {
    let element = URLQuery.Element(name: "symbol", value: "AAPL")

    #expect(element.name == "symbol")
    #expect(element.value == "AAPL")
  }

  @Test("element with nil value")
  func testElementWithNilValue() async throws {
    let element = URLQuery.Element(name: "flag", value: nil)

    #expect(element.name == "flag")
    #expect(element.value == nil)
  }

  @Test("element LosslessStringConvertible")
  func testElementLosslessStringConvertible() async throws {
    let element = URLQuery.Element(name: "count", value: 42)

    #expect(element.name == "count")
    #expect(element.value == "42")
  }

  @Test("element rawValue encoding")
  func testElementRawValueEncoding() async throws {
    let element = URLQuery.Element(name: "q", value: "hello world")
    #expect(element.rawValue == "q=hello%20world")
  }

  @Test("element rawValue with nil value")
  func testElementRawValueWithNilValue() async throws {
    let element = URLQuery.Element(name: "flag", value: nil)
    #expect(element.rawValue == "flag")
  }

  @Test("element rawValue with special characters")
  func testElementRawValueWithSpecialChars() async throws {
    let element = URLQuery.Element(name: "search", value: "hello world#test")
    #expect(element.rawValue == "search=hello%20world%23test")
  }

  @Test("element from rawValue")
  func testElementFromRawValue() async throws {
    let element = URLQuery.Element(rawValue: "symbol=AAPL")

    #expect(element?.name == "symbol")
    #expect(element?.value == "AAPL")
  }

  @Test("element from rawValue without value")
  func testElementFromRawValueWithoutValue() async throws {
    let element = URLQuery.Element(rawValue: "flag")

    #expect(element?.name == "flag")
    #expect(element?.value == nil)
  }

  @Test("empty initialization")
  func testEmptyInit() async throws {
    let query = URLQuery()

    #expect(query.storage.isEmpty)
    #expect(query.queryString == nil)
  }

  @Test("dictionary literal")
  func testDictionaryLiteral() async throws {
    let query: URLQuery = ["symbol": "AAPL", "interval": "1d"]

    #expect(query.storage.count == 2)
    #expect(query.queryString?.contains("symbol=AAPL") == true)
    #expect(query.queryString?.contains("interval=1d") == true)
  }

  @Test("dictionary literal with nil values")
  func testDictionaryLiteralWithNilValues() async throws {
    let query: URLQuery = ["flag": nil, "symbol": "AAPL"]

    #expect(query.storage.count == 2)
    #expect(query.queryString?.contains("flag") == true)
    #expect(query.queryString?.contains("symbol=AAPL") == true)
  }

  @Test("array literal")
  func testArrayLiteral() async throws {
    let query: URLQuery = [
      URLQuery.Element(name: "symbol", value: "AAPL"),
      URLQuery.Element(name: "range", value: nil),
    ]

    #expect(query.storage.count == 2)
    #expect(query.queryString == "symbol=AAPL&range")
  }

  @Test("queryString encoding")
  func testQueryStringEncoding() async throws {
    let query: URLQuery = ["name": "John Doe", "city": "New York"]

    let queryString = query.queryString
    #expect(queryString?.contains("name=John%20Doe") == true)
    #expect(queryString?.contains("city=New%20York") == true)
  }

  @Test("collection conformance")
  func testCollectionConformance() async throws {
    var query = URLQuery()
    query.append(URLQuery.Element(name: "a", value: "1"))
    query.append(URLQuery.Element(name: "b", value: "2"))

    #expect(query.count == 2)
    #expect(query[0].name == "a")
    #expect(query[1].name == "b")

    // Test mutation
    query[0] = URLQuery.Element(name: "x", value: "999")
    #expect(query[0].name == "x")
    #expect(query[0].value == "999")
  }

  @Test("append and remove")
  func testAppendAndRemove() async throws {
    var query = URLQuery()

    // Test append
    query.append(URLQuery.Element(name: "symbol", value: "AAPL"))
    #expect(query.count == 1)

    // Test remove
    query.removeAll()
    #expect(query.isEmpty)
    #expect(query.queryString == nil)
  }
}
