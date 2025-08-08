/// A collection of URL query parameters with automatic percent encoding.
///
/// `URLQuery` provides a type-safe way to build and manipulate URL query parameters
/// with automatic percent encoding. It conforms to `MutableCollection` for easy manipulation
/// and supports convenient literal syntax.
///
/// ## Usage Examples
/// ```swift
/// // Dictionary literal
/// let query: URLQuery = ["symbol": "AAPL", "interval": "1d"]
///
/// // Array literal with Elements
/// let query: URLQuery = [
///   Element(name: "symbol", value: "AAPL"),
///   Element(name: "range", value: nil)
/// ]
///
/// // Manual building
/// var query = URLQuery()
/// query.append(Element(name: "symbol", value: "AAPL"))
/// query.append(Element(name: "interval", value: 60))
///
/// // Get encoded query string
/// print(query.queryString) // "symbol=AAPL&interval=60"
/// ```
public struct URLQuery: Sendable {

  /// A single query parameter with automatic URL encoding.
  ///
  /// Each element represents a name-value pair that will be percent-encoded
  /// when converted to its raw string representation.
  public struct Element: RawRepresentable, Hashable, Sendable {

    /// The parameter name
    public var name: String

    /// The parameter value (nil represents a parameter without a value)
    public var value: String?

    /// URL-encoded string representation of the parameter.
    ///
    /// Returns the parameter in `name=value` format with proper percent encoding.
    /// If encoding fails, returns empty string for invalid names or just the encoded name for parameters without values.
    ///
    /// ## Examples
    /// ```swift
    /// Element(name: "q", value: "hello world").rawValue  // "q=hello%20world"
    /// Element(name: "flag", value: nil).rawValue         // "flag"
    /// ```
    public var rawValue: String {
      guard let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        return ""
      }

      guard
        let value,
        let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
      else {
        return encodedName
      }

      return "\(encodedName)=\(encodedValue)"
    }

    /// Creates a query parameter with optional value.
    ///
    /// - Parameters:
    ///   - name: The parameter name
    ///   - value: The parameter value (nil for parameters without values)
    public init(name: String, value: String?) {
      self.name = name
      self.value = value
    }

    /// Creates a query parameter with a non-optional value.
    ///
    /// - Parameters:
    ///   - name: The parameter name
    ///   - value: The parameter value
    public init(name: String, value: String) {
      self.init(name: name, value: Optional(value))
    }

    /// Creates a query parameter from a URL-encoded string.
    ///
    /// Parses a string in `name=value` or `name` format.
    ///
    /// - Parameter rawValue: The encoded parameter string
    /// - Returns: The parsed Element, or nil if parsing fails
    public init?(rawValue: String) {
      let components = rawValue.components(separatedBy: "=")
      guard let name = components.first else {
        return nil
      }

      self.name = name
      self.value = components.count == 2 ? components[1] : nil
    }

    /// Creates a query parameter with a value that can be converted to String.
    ///
    /// - Parameters:
    ///   - name: The parameter name
    ///   - value: The parameter value (will be converted to String)
    public init<T: LosslessStringConvertible>(name: String, value: T) {
      self.init(name: name, value: String(value))
    }
  }

  /// Internal storage for query elements
  public var storage: [Element]

  /// Creates an empty query parameter collection.
  public init() {
    self.storage = []
  }

  /// The complete query string without the "?" prefix.
  ///
  /// Returns all parameters joined with "&" separators, with automatic percent encoding.
  /// Returns nil if no parameters are present.
  ///
  /// ## Example
  /// ```swift
  /// let query: URLQuery = ["name": "John Doe", "age": "30"]
  /// print(query.queryString) // "name=John%20Doe&age=30"
  /// ```
  public var queryString: String? {
    guard !storage.isEmpty else {
      return nil
    }

    return storage.map(\.rawValue).joined(separator: "&")
  }
}

// MARK: - Collection
extension URLQuery: RangeReplaceableCollection, RandomAccessCollection, MutableCollection {

  public typealias Index = Int

  public var startIndex: Int {
    storage.startIndex
  }

  public var endIndex: Int {
    storage.endIndex
  }

  public subscript(position: Int) -> Element {
    get { storage[position] }
    set { storage[position] = newValue }
  }

  public mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C)
  where C: Collection, Element == C.Element {
    storage.replaceSubrange(subrange, with: newElements)
  }
}

// MARK: - ExpressibleByArrayLiteral
extension URLQuery: ExpressibleByArrayLiteral {

  public init(arrayLiteral elements: Element...) {
    self.storage = elements
  }
}

// MARK: - ExpressibleByDictionaryLiteral
extension URLQuery: ExpressibleByDictionaryLiteral {

  public init(dictionaryLiteral elements: (String, String?)...) {
    self.storage = elements.map(Element.init)
  }
}
