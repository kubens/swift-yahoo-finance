import HTTPTypes

import class Foundation.JSONDecoder

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

  /// The User-Agent used for all requests from this instance.
  ///
  /// Each YahooFinance instance uses a consistent User-Agent to maintain session coherence
  /// for cookies and other security mechanisms that Yahoo Finance may employ.
  private let userAgent: UserAgent

  private var decoder: JSONDecoder

  /// Creates a new YahooFinance instance with the specified transport and User-Agent.
  ///
  /// The transport parameter allows you to inject your preferred HTTP client implementation, enabling
  /// flexibility in networking approaches and testing scenarios. The userAgent parameter allows you to
  /// specify a consistent User-Agent for all requests from this instance, which helps maintain session
  /// coherence for cookies and other security mechanisms.
  ///
  /// - Parameters:
  ///   - transport: The HTTP transport to use for network operations
  ///   - userAgent: The User-Agent to use for all requests. Defaults to a random selection
  ///
  /// ## Usage Examples
  /// ```swift
  /// // With random User-Agent (default)
  /// let yahooFinance = YahooFinance(transport: transport)
  ///
  /// // With specific User-Agent
  /// let yahooFinance = YahooFinance(transport: transport, userAgent: .safari)
  /// ```
  public init(transport: ClientTransport, userAgent: UserAgent = .random) {
    self.transport = transport
    self.userAgent = userAgent
    self.decoder = JSONDecoder()
  }

  /// Performs a Yahoo Finance request and decodes the response to the specified type.
  ///
  /// This method handles the complete request lifecycle including converting the Request to HTTPRequest,
  /// adding necessary headers and authentication, sending through the configured transport,
  /// and decoding the returned data.
  ///
  /// - Parameter request: The Yahoo Finance request to perform
  /// - Returns: The decoded response object of the specified type
  /// - Throws: ``YahooFinanceError`` for various failure conditions including network errors, invalid responses,
  ///   authentication failures, or decoding errors
  ///
  /// ## Usage Example
  /// ```swift
  /// let request = Request<StockQuote>(
  ///   authority: "query1.finance.yahoo.com",
  ///   path: "/v8/finance/chart/AAPL"
  /// )
  /// let quote = try await yahooFinance.perform(request)
  /// ```
  public func perform<Response>(_ request: Request<Response>) async throws -> Response {
    let httpRequest = try buildHTTPRequest(from: request)

    do {
      let (data, httpResponse) = try await transport.send(httpRequest, body: request.body)

      if httpResponse.status == .unauthorized {
        throw YahooFinanceError.authenticationFailed
      }

      if httpResponse.status != .ok {
        throw YahooFinanceError.invalidResponse(httpResponse.status)
      }

      return try decoder.decode(Response.self, from: data)
    } catch let error as DecodingError {
      throw YahooFinanceError.decodingError(error)
    } catch let error as YahooFinanceError {
      throw error
    } catch {
      throw YahooFinanceError.networkError(error)
    }
  }

  /// Converts a Request to HTTPRequest with additional Yahoo Finance specific data.
  ///
  /// This internal method handles the conversion from high-level Request to HTTPRequest,
  /// adding necessary headers, authentication tokens, and other Yahoo Finance specific
  /// requirements like crumb management.
  ///
  /// - Parameter request: The Request to convert
  /// - Returns: A configured HTTPRequest ready for transport
  /// - Throws: ``YahooFinanceError.invalidURL`` if URL construction fails
  private func buildHTTPRequest<Response>(from request: Request<Response>) throws -> HTTPRequest {
    // Build path with query string if needed
    let fullPath = request.path + (request.query.queryString.map { "?" + $0 } ?? "")

    var httpRequest = HTTPRequest(
      method: request.method,
      scheme: request.scheme,
      authority: request.authority,
      path: fullPath
    )

    httpRequest.headerFields[.userAgent] = userAgent.rawValue

    // TODO: Add authentication/crumb if needed

    return httpRequest
  }
}
