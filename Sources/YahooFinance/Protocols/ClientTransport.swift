import HTTPTypes

import struct Foundation.Data

/// Protocol defining the contract for HTTP client transport in Yahoo Finance API communication.
///
/// This protocol abstracts the HTTP transport layer, allowing for different implementations such as URLSession,
/// AsyncHTTPClient, or custom transport mechanisms while maintaining a consistent interface for Yahoo Finance data
/// fetching operations.
///
/// ## Usage Example
/// ```swift
/// struct MyTransport: ClientTransport {
///   func send(_ request: HTTPRequest, body: Data?) async throws -> (Data, HTTPResponse) {
///     // Implementation specific transport logic
///   }
/// }
/// ```
public protocol ClientTransport: Sendable {
  /// Sends an HTTP request and returns the response data and metadata.
  ///
  /// This method handles the core HTTP communication for Yahoo Finance API requests, including authentication,
  /// crumb management, and data retrieval operations.
  ///
  /// - Parameters:
  ///   - request: The HTTP request to send, containing URL, headers, and method information
  ///   - body: Optional request body data for POST/PUT operations
  /// - Returns: A tuple containing the response data and HTTP response metadata
  /// - Throws: Transport-specific errors for network failures, timeouts, or HTTP errors
  func send(_ request: HTTPRequest, body: Data?) async throws -> (Data, HTTPResponse)
}
