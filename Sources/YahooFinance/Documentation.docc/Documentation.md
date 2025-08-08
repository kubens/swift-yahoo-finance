# ``YahooFinance``

A cross-platform Swift library for accessing Yahoo Finance data through their unofficial API.

## Overview

YahooFinance provides a modern, Swift-native way to fetch financial data from Yahoo Finance services. Built with Swift 6.0+ concurrency features, it supports both Apple platforms and Linux environments, making it suitable for iOS/macOS applications as well as server-side Swift projects using [Vapor](https://vapor.codes) or [Hummingbird](https://hummingbird.codes).

> Important: This is NOT an official Yahoo Finance library. NOT written, endorsed, or sponsored by Yahoo Inc. This library is intended for educational and personal use. Uses unofficial Yahoo Finance APIs that may change without notice. Users are solely responsible for compliance with Yahoo's Terms of Service and usage policies. Use at your own risk and ensure you follow all applicable terms and conditions.

### Key Features

- **Cross-Platform**: Works on Apple platforms and Linux
- **Modern Swift**: Uses Swift 6.0+ with async/await and actors
- **Flexible Transport**: Pluggable HTTP transport layer via ``ClientTransport`` protocol
- **Type Safety**: Leverages swift-http-types for safe HTTP handling
- **Server Ready**: Compatible with Vapor, Hummingbird, and other Swift on Server frameworks

## Getting Started

### Basic Usage

```swift
import YahooFinance

// Create your transport implementation
let transport = MyClientTransport()

// Initialize YahooFinance
let yahooFinance = YahooFinance(transport: transport)

// Create a request with query parameters
let query: URLQuery = ["symbol": "AAPL", "interval": "1d"]
let request = Request<StockData>(
  authority: "query1.finance.yahoo.com",
  path: "/v8/finance/chart",
  query: query
)

// Fetch data
let stockData = try await yahooFinance.perform(request)
```

## Topics

### Core Components

- ``YahooFinance``
- ``Request``
- ``URLQuery``
- ``ClientTransport``
- ``UserAgent``

### Error Handling

- ``YahooFinanceError``