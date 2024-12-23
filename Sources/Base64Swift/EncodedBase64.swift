//
//  EncodedBase64.swift
//  base64-swift
//
//  Created by Robert Nash on 23/12/2024.
//

import Foundation

/// A type that represents a standard Base64-encoded string.
///
/// Base64 is a binary-to-text encoding scheme that represents binary data
/// in an ASCII string format. This structure provides utilities for decoding
/// Base64 strings into raw data or byte arrays and for encoding raw data
/// into Base64 strings.
public struct EncodedBase64: RawRepresentable, Codable, Hashable, Equatable {
    
    /// The raw Base64-encoded string.
    public let rawValue: String
    
    /// The decoded data from the Base64 string.
    ///
    /// - Returns: A `Data` object representing the decoded binary data.
    /// - Throws: A runtime error if the Base64 string is invalid. This force-unwrapping is safe
    ///   as the string is validated during initialisation.
    public var data: Data {
        Data(base64Encoded: rawValue)!
    }

    /// The decoded bytes from the Base64 string.
    ///
    /// This property converts the decoded data into an array of bytes.
    ///
    /// - Returns: An array of bytes (`[UInt8]`) representing the decoded data.
    public var bytes: [UInt8] {
        [UInt8](data)
    }
    
    /// Creates a Base64-encoded representation from a raw string.
    ///
    /// This initialiser supports two scenarios:
    /// 1. **Valid Base64 Input**: If the provided string is valid Base64, it is stored as-is.
    ///    No additional encoding, repairs, or padding corrections are performed.
    /// 2. **Raw String Input**: If the provided string is not valid Base64 but can be converted to UTF-8 data,
    ///    it is treated as raw data and encoded into a Base64 representation.
    ///
    /// Note: Strict validation is applied for Base64 inputs. Improperly padded or otherwise invalid Base64 strings
    /// are not corrected and will result in the initialiser returning `nil`.
    ///
    /// - Parameter rawValue: A string that is either a valid Base64-encoded string or raw input to be encoded.
    /// - Returns: `nil` if the string is empty, invalid as Base64, or cannot be converted to UTF-8 data.
    public init?(rawValue: String) {
        if rawValue.isEmpty {
            return nil
        } else if Data(base64Encoded: rawValue) != nil {
            self.rawValue = rawValue
        } else if let data = rawValue.data(using: .utf8) {
            self.rawValue = data.base64EncodedString()
        } else {
            return nil
        }
    }
    
    /// Creates a Base64-encoded representation from a byte array.
    ///
    /// - Parameter bytes: The byte array to encode.
    /// - Returns: `nil` if the byte array is empty.
    public init?(bytes: [UInt8]) {
        if bytes.isEmpty {
            return nil
        }
        let data = Data(bytes: bytes, count: bytes.count)
        self.rawValue = data.base64EncodedString()
    }
    
    /// Creates a Base64-encoded representation from raw data.
    ///
    /// - Parameter data: The data to encode.
    /// - Returns: `nil` if the data cannot be converted to a Base64 string.
    public init?(data: Data) {
        self.init(bytes: Array(data))
    }
    
    /// Creates a Base64-encoded representation from a URLEncodedBase64 string.
    ///
    /// This initialiser transforms a Base64URL string into standard Base64 format
    /// by replacing URL-safe characters and adding padding if necessary.
    ///
    /// - Parameter urlEncoded: A Base64URL-encoded string.
    init(urlEncoded: URLEncodedBase64) {
        rawValue = urlEncoded.toBase64String()
    }
    
    /// The Base64URL representation of the Base64 string.
    ///
    /// This property transforms the Base64 string into a Base64URL format by replacing
    /// characters `+` with `-` and `/` with `_`, and removing padding (`=`).
    public var urlEncoded: URLEncodedBase64 {
        URLEncodedBase64(base64: self)
    }
    
    func toURLEncodedBase64String() -> String {
        rawValue
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    /// Decodes a Base64-encoded string from the provided decoder.
    ///
    /// This method expects the value to be a valid Base64 string.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: `DecodingError.dataCorruptedError` if the value is not a valid Base64 string.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        guard let value = EncodedBase64(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid raw value: \(rawValue)")
        }
        self = value
    }

    /// Encodes the Base64 string into the provided encoder.
    ///
    /// This method writes the `rawValue` as a single string.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: An error if encoding fails.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
