//
//  URLEncodedBase64.swift
//  base64-swift
//
//  Created by Robert Nash on 23/12/2024.
//

import Foundation

/// A type that represents a Base64URL-encoded string.
///
/// Base64URL is a URL-safe variant of Base64 encoding that replaces the characters
/// `+` and `/` with `-` and `_` respectively, and removes padding characters (`=`).
///
/// This structure provides utilities for decoding Base64URL strings into raw data or
/// byte arrays and for converting data into Base64URL-encoded strings.
public struct URLEncodedBase64: RawRepresentable, Codable, Hashable, Equatable {
    
    /// The raw Base64URL-encoded string.
    public let rawValue: String

    /// The decoded bytes from the Base64URL string.
    ///
    /// This property first transforms the Base64URL-encoded string into a standard Base64
    /// format, then decodes it into raw bytes.
    ///
    /// - Returns: An array of bytes (`[UInt8]`) representing the decoded data.
    public var bytes: [UInt8] {
        urlDecoded.bytes
    }
    
    /// The standard Base64 representation of the Base64URL string.
    ///
    /// This property transforms the Base64URL-encoded string into a standard Base64 format
    /// by replacing URL-safe characters and adding padding if necessary.
    public var urlDecoded: EncodedBase64 {
        EncodedBase64(urlEncoded: self)
    }

    /// Creates a Base64URL-encoded representation from a standard Base64 string.
    ///
    /// This initialiser transforms the provided Base64 string by replacing characters
    /// `+` with `-` and `/` with `_`, and removes any padding (`=`).
    ///
    /// - Parameter base64: A standard Base64-encoded string.
    public init(base64: EncodedBase64) {
        rawValue = base64.toURLEncodedBase64String()
    }
    
    /// Creates a Base64URL-encoded representation from a raw string.
    ///
    /// - Parameter rawValue: A Base64URL-encoded string.
    /// - Returns: `nil` if the provided string is not a valid Base64URL-encoded string.
    public init?(rawValue: String) {
        
        if rawValue.isURLEncodedBase64 {
            self.rawValue = rawValue
        } else if let this = EncodedBase64(rawValue: rawValue) {
            self.rawValue = this.urlEncoded.rawValue
        } else {
            return nil
        }
    }
    
    func toBase64String() -> String {
        rawValue.toBase64()
    }
    
    /// Creates a Base64URL-encoded representation from raw data.
    ///
    /// - Parameter data: The data to encode into a Base64URL-encoded string.
    /// - Returns: `nil` if the data could not be encoded.
    public init?(data: Data) {
        guard let this = EncodedBase64(data: data) else {
            return nil
        }
        self.init(base64: this)
    }
    
    /// Creates a Base64URL-encoded representation from a byte array.
    ///
    /// - Parameter bytes: The byte array to encode into a Base64URL-encoded string.
    /// - Returns: `nil` if the byte array could not be encoded.
    public init?(bytes: [UInt8]) {
        guard let this = EncodedBase64(bytes: bytes) else {
            return nil
        }
        self.init(base64: this)
    }

    /// Decodes a Base64URL-encoded string from the provided decoder.
    ///
    /// This method expects the value to be a valid Base64URL-encoded string.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: `DecodingError.dataCorruptedError` if the value is not a valid Base64URL-encoded string.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        guard let value = URLEncodedBase64(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid raw value: \(rawValue)")
        }
        self = value
    }

    /// Encodes the Base64URL string into the provided encoder.
    ///
    /// This method writes the `rawValue` as a single string.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: An error if encoding fails.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

// Must remain private to this file because it's purpose if for URLEncodedBase64 content only.
private extension String {
    
    /// from URLEncodedBase64 to Base64
    func toBase64() -> String {
        var value = self
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        while value.count % 4 != 0 {
            value = value.appending("=")
        }
        return value
    }
    
    var isURLEncodedBase64: Bool {
        if isEmpty {
            return false
        }
        let allowedCharacterSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_")
        if rangeOfCharacter(from: allowedCharacterSet.inverted) != nil {
            return false
        }
        // Check if the Base64 conversion produces valid data
        let data = Data(base64Encoded: toBase64())
        return data != nil
    }
}
