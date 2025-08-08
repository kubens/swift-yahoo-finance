import HTTPTypes

/// Main entry point for Yahoo Finance API operations.
///
/// `YahooFinance` is the primary interface for interacting with Yahoo Finance services. It provides a safe,
/// concurrent API built on Swift's actor model to handle authentication, request management, and data fetching
/// operations.
///
/// This actor serves as a coordinating layer between your application and Yahoo Finance's unofficial APIs,
/// managing HTTP transport, error handling, and response processing through a pluggable architecture.
///
/// ## Usage Example
/// ```swift
/// import YahooFinance
///
/// // Create your transport implementation
/// let transport = URLSessionTransport()
///
/// // Initialize YahooFinance
/// let yahooFinance = YahooFinance(transport: transport)
///
/// // Fetch stock data
/// let request = HTTPRequest(method: .get, scheme: "https", authority: "finance.yahoo.com", path: "/api/data")
/// let stockData = try await yahooFinance.perform(request, as: StockResponse.self)
/// ```
///
/// ## Thread Safety
/// As an actor, `YahooFinance` ensures thread-safe access to its internal state and provides safe concurrent
/// access to Yahoo Finance APIs from multiple tasks.
public actor YahooFinance {

  /// The HTTP transport used for network communication.
  ///
  /// This transport handles the actual HTTP requests and responses, allowing for different implementations
  /// such as URLSession, AsyncHTTPClient, or custom networking solutions.
  internal let transport: ClientTransport

  /// Creates a new YahooFinance instance with the specified transport.
  ///
  /// The transport parameter allows you to inject your preferred HTTP client implementation, enabling
  /// flexibility in networking approaches and testing scenarios.
  ///
  /// - Parameter transport: The HTTP transport to use for network operations
  ///
  /// ## Usage Example
  /// ```swift
  /// let transport = URLSessionTransport()
  /// let yahooFinance = YahooFinance(transport: transport)
  /// ```
  public init(transport: ClientTransport) {
    self.transport = transport
  }

  /// Performs an HTTP request and decodes the response to the specified type.
  ///
  /// This method handles the complete request lifecycle including sending the HTTP request through the
  /// configured transport, processing the response, and decoding the returned data into the requested type.
  ///
  /// - Parameters:
  ///   - request: The HTTP request to send to Yahoo Finance APIs
  ///   - type: The type to decode the response data into
  /// - Returns: The decoded response object of the specified type
  /// - Throws: ``YahooFinanceError`` for various failure conditions including network errors, invalid responses,
  ///   authentication failures, or decoding errors
  ///
  /// ## Usage Example
  /// ```swift
  /// let request = HTTPRequest(method: .get, scheme: "https", authority: "finance.yahoo.com", path: "/api/quote")
  /// let quote = try await yahooFinance.perform(request, as: StockQuote.self)
  /// ```
  public func perform<T: Decodable>(_ request: HTTPRequest, as type: T.Type) async throws -> T {
    fatalError("Not implement yet")
  }
}
