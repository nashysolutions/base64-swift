# base64-swift

A lightweight Swift library providing useful utilities for handling Base64 encoding and decoding. Simplify working with Base64 strings in your applications with concise, modern Swift APIs. This logic was lifted from [here](https://github.com/nashysolutions/webauthn-swift-models) and changed slightly for more general use.

## Features

- **Base64 Encoding**: Easily encode strings or data to Base64 format.
- **Base64 Decoding**: Decode Base64 strings back to their original form.
- **Error Handling**: Robust error handling for invalid Base64 inputs.
- **Modern Swift**: Written with Swift 6 best practices and seamless integration into any Swift project.

## Installation

### Swift Package Manager

To add `base64-swift` to your project:

1. Open your project in Xcode.
2. Go to **File > Add Packages**.
3. Enter the repository URL: `https://github.com/yourusername/base64-swift`.
4. Choose the version or branch and integrate the package.

Alternatively, add the dependency directly to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/nashysolutions/base64-swift", from: "1.0.0")
]
```

## Acknowledgements

This project incorporates modified code from the WebAuthn Swift project, which is an open-source initiative for implementing the WebAuthn spec in Swift. We are grateful to the authors and contributors of the WebAuthn Swift project for their pioneering efforts in web authentication.
