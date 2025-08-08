import HTTPTypes

import struct Foundation.Data

/// A generic request structure for Yahoo Finance API calls.
///
/// This struct encapsulates all the necessary information needed to make a request
/// to the Yahoo Finance API, with support for generic response types and extensible
/// configuration options.
///
/// - Parameter Response: The expected response type that conforms to `Decodable` and `Sendable`
public struct Request<Response>: Sendable where Response: Decodable & Sendable {

  /// The HTTP method for the request
  public let method: HTTPRequest.Method

  /// The URL scheme (e.g., "https")
  public let scheme: String

  /// The authority/host (e.g., "query1.finance.yahoo.com")
  public let authority: String

  /// The path component of the request URL
  public let path: String

  /// Query parameters to be included in the request
  public let query: URLQuery

  /// The request body data, if any
  public let body: Data?

  /// Creates a new Request instance.
  ///
  /// - Parameters:
  ///   - method: The HTTP method to use for the request. Defaults to `.get`
  ///   - scheme: The URL scheme. Defaults to "https"
  ///   - authority: The authority/host for the Yahoo Finance API endpoint
  ///   - path: The path component of the request URL
  ///   - query: Query parameters to include in the request. Defaults to empty URLQuery
  ///   - body: Optional request body data. Defaults to nil
  public init(
    method: HTTPRequest.Method = .get,
    scheme: String = "https",
    authority: String,
    path: String,
    query: URLQuery = [],
    body: Data? = nil
  ) {
    self.method = method
    self.scheme = scheme
    self.authority = authority
    self.path = path
    self.query = query
    self.body = body
  }
}
