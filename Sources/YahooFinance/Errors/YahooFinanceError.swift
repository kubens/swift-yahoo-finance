import HTTPTypes

/// Errors that can occur during Yahoo Finance API operations.
///
/// This enum represents all possible error conditions that may arise when interacting with Yahoo Finance services,
/// including authentication failures, network issues, and data processing problems.
///
/// ## Error Categories
/// - Authentication: Issues with Yahoo Finance authentication and session management
/// - Network: Problems with HTTP communication and connectivity
/// - Data Processing: Errors during response parsing and data decoding
public enum YahooFinanceError: Error, Sendable {
  /// Authentication with Yahoo Finance services failed.
  ///
  /// This error occurs when the authentication process fails, such as invalid credentials, expired sessions,
  /// or missing authentication tokens required for Yahoo Finance API access.
  case authenticationFailed

  /// Received an invalid or unexpected HTTP response.
  ///
  /// This error indicates that the server returned a response with an unexpected status code or format.
  ///
  /// - Parameter status: The HTTP response status that caused the error
  case invalidResponse(HTTPResponse.Status)

  /// A network error occurred during the request.
  ///
  /// This error wraps underlying network-related failures such as connection timeouts, DNS resolution failures,
  /// or other transport-layer issues.
  ///
  /// - Parameter underlying: The original network error that occurred
  case networkError(Error)

  /// Failed to decode the response data.
  ///
  /// This error occurs when the response data cannot be parsed into the expected format, indicating either
  /// malformed data from the server or a mismatch between expected and actual data structure.
  ///
  /// - Parameter underlying: The original decoding error that occurred
  case decodingError(Error)
}
