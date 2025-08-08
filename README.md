# YahooFinance

[![Swift](https://img.shields.io/badge/Swift-6.0+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2015%20|%20macOS%2012%20|%20watchOS%208%20|%20tvOS%2013%20|%20Linux-blue.svg)](https://swift.org)
[![SPM](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

A cross-platform Swift library for accessing Yahoo Finance data through their unofficial API.

## ⚠️ Important Disclaimers

**This is NOT an official Yahoo Finance library**
- NOT written, endorsed, or sponsored by Yahoo Inc.
- This library is intended for educational and personal use
- Uses unofficial Yahoo Finance APIs that may change without notice
- Users are solely responsible for compliance with Yahoo's Terms of Service and usage policies
- Use at your own risk and ensure you follow all applicable terms and conditions

## Features

- **Cross-Platform**: Works on Apple platforms (iOS, macOS, watchOS, tvOS) and Linux
- **Modern Swift**: Built with Swift 6.0+ using async/await and actors
- **Flexible Architecture**: Pluggable HTTP transport layer via `ClientTransport` protocol
- **Type Safety**: Leverages swift-http-types for safe HTTP handling
- **Server Ready**: Compatible with Vapor, Hummingbird, and other Swift on Server frameworks
- **Comprehensive Error Handling**: Detailed error types for different failure scenarios

## Requirements

- Swift 6.0+
- Platforms: iOS 15.0+, macOS 12.0+, watchOS 8.0+, tvOS 13.0+, Linux

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
  .package(url: "https://github.com/kubens/swift-yahoo-finance", branch: "main")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter the repository URL
3. Select the version you want to use

## Basic Usage

```swift
import YahooFinance

// Create your transport implementation
let transport = MyClientTransport()

// Initialize YahooFinance
let yahooFinance = YahooFinance(transport: transport)

// Fetch data (example implementation)
let data = try await yahooFinance.perform(request, responseAs: MyDataType.self)
```

## Architecture

The library is built around a few core components:

- **`YahooFinance`**: Main entry point actor for all operations
- **`ClientTransport`**: Protocol for HTTP transport implementations
- **`YahooFinanceError`**: Comprehensive error handling

## Error Handling

The library provides detailed error information through `YahooFinanceError`:

- `authenticationFailed`: Authentication issues
- `invalidResponse(HTTPResponse.Status)`: HTTP response errors
- `networkError(Error)`: Network connectivity problems  
- `decodingError(Error)`: Data parsing failures

## Development

### Building

```bash
swift build
```

### Testing

```bash
swift test
```

### Documentation

```bash
swift package generate-documentation
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Follow coding standards (SRP, DRY, KISS, Apple semantics)
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Legal Notice

This library is not affiliated with, endorsed by, or sponsored by Yahoo Inc. Yahoo Finance is a trademark of Yahoo Inc. Users of this library are responsible for ensuring their usage complies with Yahoo's Terms of Service and any applicable laws and regulations.