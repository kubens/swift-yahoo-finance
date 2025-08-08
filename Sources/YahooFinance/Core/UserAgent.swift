/// Predefined User-Agent strings for Yahoo Finance API requests.
///
/// Different User-Agent strings may be required for various Yahoo Finance endpoints
/// to ensure proper access and avoid rate limiting. This enum provides commonly
/// used User-Agent values that work well with Yahoo Finance services.
///
/// ## Usage Example
/// ```swift
/// let userAgent = UserAgent.safari.rawValue
/// httpRequest.headerFields[.userAgent] = userAgent
///
/// // Or use random
/// let randomUserAgent = UserAgent.random.rawValue
/// ```
public enum UserAgent: String, Sendable, CaseIterable {

  /// Safari browser on macOS
  case safari =
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Version/17.0 Safari/537.36"

  /// Chrome browser on macOS
  case chrome =
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

  /// Generic mobile browser
  case mobile =
    "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"

  /// Returns a random User-Agent from available options
  public static var random: UserAgent {
    return allCases.randomElement() ?? .safari
  }
}
