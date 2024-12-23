//
//  URLEncodedBase64Tests.swift
//  base64-swift
//
//  Created by Robert Nash on 23/12/2024.
//

import Foundation
import Testing

@testable import Base64Swift

@Suite("URLEncodedBase64 Tests")
struct URLEncodedBase64Tests {
    
    @Test("Initialisation with valid Base64URL string.")
    func testInitialisationWithValidBase64URL() {
        /// Given
        /// A valid Base64URL-encoded string.
        let validBase64URL = "SGVsbG8td29ybGQ_"

        /// When
        /// Initialising `URLEncodedBase64` with the string.
        let result = URLEncodedBase64(rawValue: validBase64URL)

        /// Then
        /// The initialisation succeeds and retains the original value.
        assert(result != nil, "Expected non-nil for valid Base64URL input.")
        assert(result?.rawValue == validBase64URL, "Expected rawValue to match the input Base64URL string.")
    }
    
    @Test("Initialisation with invalid Base64URL string.")
    func testInitialisationWithInvalidBase64URL() {
        /// Given
        /// Invalid Base64URL-encoded strings containing invalid characters.
        let invalidBase64URLA = "SGVsbG8-t29ybGQ_*"
        let invalidBase64URLB = "SGVsbG8-d29ybGQ*"
        
        /// When
        /// Initialising `URLEncodedBase64`
        let resultA = URLEncodedBase64(rawValue: invalidBase64URLA)
        let resultB = URLEncodedBase64(rawValue: invalidBase64URLB)
        
        /// Then
        /// The initialisation succeeds.
        let message = "Expected a result for invalid Base64 string. The value is simply treated as a string. The onus is on you to validate the provided data."
        assert(resultA?.rawValue == "U0dWc2JHOC10Mjl5YkdRXyo", message)
        assert(resultB?.rawValue == "U0dWc2JHOC1kMjl5YkdRKg", "Expected nil for Base64URL string with invalid characters.")
    }
    
    @Test("Initialisation with standard Base64 string.")
    func testInitialisationWithStandardBase64() {
        /// Given
        /// A standard Base64-encoded string.
        let standardBase64 = "SGVsbG8+d29ybGQ/"

        /// When
        /// Initialising `URLEncodedBase64` with the string.
        let result = URLEncodedBase64(rawValue: standardBase64)

        /// Then
        /// The initialisation succeeds and converts the value to Base64URL format.
        let expectedBase64URL = "SGVsbG8-d29ybGQ_"
        assert(result != nil, "Expected non-nil for valid Base64 input.")
        assert(result?.rawValue == expectedBase64URL, "Expected rawValue to match the converted Base64URL string.")
    }
    
    @Test("Initialisation with empty string.")
    func testInitialisationWithEmptyString() {
        /// Given
        /// An empty string.
        let emptyString = ""

        /// When
        /// Initialising `URLEncodedBase64` with the string.
        let result = URLEncodedBase64(rawValue: emptyString)

        /// Then
        /// The initialisation fails.
        assert(result == nil, "Expected nil for empty string input.")
    }
    
    @Test("Encoding raw data to Base64URL.")
    func testEncodingRawDataToBase64URL() throws {
        /// Given
        /// Raw data to encode.
        let rawData = try #require("Hello world".data(using: .utf8))

        /// When
        /// Initialising `URLEncodedBase64` with the raw data.
        let result = URLEncodedBase64(data: rawData)

        /// Then
        /// The initialisation succeeds and produces the correct Base64URL-encoded string.
        let expectedBase64URL = "SGVsbG8gd29ybGQ"
        assert(result != nil, "Expected non-nil for raw data input.")
        assert(result?.rawValue == expectedBase64URL, "Expected rawValue to match the Base64URL-encoded string of the raw data.")
    }
    
    @Test("Encoding byte array to Base64URL.")
    func testEncodingByteArrayToBase64URL() {
        /// Given
        /// A byte array to encode.
        let byteArray: [UInt8] = [72, 101, 108, 108, 111]

        /// When
        /// Initialising `URLEncodedBase64` with the byte array.
        let result = URLEncodedBase64(bytes: byteArray)

        /// Then
        /// The initialisation succeeds and produces the correct Base64URL-encoded string.
        let expectedBase64URL = "SGVsbG8"
        assert(result != nil, "Expected non-nil for byte array input.")
        assert(result?.rawValue == expectedBase64URL, "Expected rawValue to match the Base64URL-encoded string of the byte array.")
    }
    
    @Test("Conversion from Base64URL to Base64.")
    func testConversionFromBase64URLToBase64() {
        /// Given
        /// A valid Base64URL-encoded string.
        let base64URL = "SGVsbG8-d29ybGQ_"

        /// When
        /// Converting the Base64URL string to standard Base64.
        let result = URLEncodedBase64(rawValue: base64URL)?.toBase64String()

        /// Then
        /// The conversion succeeds and produces the correct Base64 string.
        let expectedBase64 = "SGVsbG8+d29ybGQ/"
        assert(result == expectedBase64, "Expected Base64 string to match the converted value.")
    }
    
    @Test("Decoding Base64URL to bytes.")
    func testDecodingBase64URLToBytes() {
        /// Given
        /// A valid Base64URL-encoded string.
        let base64URL = "SGVsbG8gd29ybGQ"

        /// When
        /// Decoding the string into bytes.
        let result = URLEncodedBase64(rawValue: base64URL)?.bytes

        /// Then
        /// The decoding succeeds and produces the correct byte array.
        let expectedBytes: [UInt8] = Array("Hello world".utf8)
        assert(result == expectedBytes, "Expected decoded bytes to match the original byte array.")
    }
    
    @Test("Initialisation with raw Data.")
    func testInitialisationWithRawData() throws {
        /// Given
        /// A valid raw data object.
        let rawData = try #require("Hello world".data(using: .utf8))

        /// When
        /// Initialising `URLEncodedBase64` with the data.
        let result = URLEncodedBase64(data: rawData)

        /// Then
        /// The initialisation succeeds and produces the correct Base64URL-encoded string.
        let expectedBase64URL = "SGVsbG8gd29ybGQ"
        assert(result != nil, "Expected non-nil for valid raw data input.")
        assert(result?.rawValue == expectedBase64URL, "Expected rawValue to match the Base64URL encoding of the input data.")
    }
    
    @Test("Initialisation with byte array.")
    func testInitialisationWithByteArray() {
        /// Given
        /// A valid byte array.
        let byteArray: [UInt8] = [72, 101, 108, 108, 111] // "Hello"

        /// When
        /// Initialising `URLEncodedBase64` with the byte array.
        let result = URLEncodedBase64(bytes: byteArray)

        /// Then
        /// The initialisation succeeds and produces the correct Base64URL-encoded string.
        let expectedBase64URL = "SGVsbG8"
        assert(result != nil, "Expected non-nil for valid byte array input.")
        assert(result?.rawValue == expectedBase64URL, "Expected rawValue to match the Base64URL encoding of the byte array.")
    }
    
    @Test("Encoding Base64URL using Codable.")
    func testEncodingBase64URLUsingCodable() {
        /// Given
        /// A valid Base64URL object.
        let base64URL = URLEncodedBase64(rawValue: "SGVsbG8gd29ybGQ")

        /// When
        /// Encoding the Base64URL object using JSONEncoder.
        let encoder = JSONEncoder()
        let encodedData = try? encoder.encode(base64URL)

        /// Then
        /// The encoding succeeds and produces the correct JSON representation.
        let expectedJSONString = "\"SGVsbG8gd29ybGQ\"" // JSON-encoded string of the Base64URL
        let resultJSONString = encodedData.flatMap { String(data: $0, encoding: .utf8) }
        assert(resultJSONString == expectedJSONString, "Expected JSON string to match the Base64URL-encoded string.")
    }
    
    @Test("Decoding Base64URL using Codable.")
    func testDecodingBase64URLUsingCodable() throws {
        /// Given
        /// A valid JSON-encoded Base64URL string.
        let jsonString = "\"SGVsbG8gd29ybGQ\"" // JSON string representing the Base64URL-encoded value.
        let jsonData = try #require(jsonString.data(using: .utf8))

        /// When
        /// Decoding the JSON string into a URLEncodedBase64 object.
        let decoder = JSONDecoder()
        let result = try? decoder.decode(URLEncodedBase64.self, from: jsonData)

        /// Then
        /// The decoding succeeds and produces the correct value.
        assert(result != nil, "Expected non-nil result when decoding a valid JSON Base64URL string.")
        assert(result?.rawValue == "SGVsbG8gd29ybGQ", "Expected rawValue to match the decoded Base64URL string.")
    }
    
    @Test("Initialisation with empty Data.")
    func testInitialisationWithEmptyData() {
        /// Given
        /// An empty Data object.
        let emptyData = Data()

        /// When
        /// Initialising `URLEncodedBase64` with the empty data.
        let result = URLEncodedBase64(data: emptyData)

        /// Then
        /// The initialisation should fail.
        assert(result == nil, "Expected nil for empty data input.")
    }
    
    @Test("Initialisation with empty byte array")
    func testInitialisationWithEmptyByteArray() {
        /// Given
        /// An empty byte array.
        let emptyByteArray: [UInt8] = []

        /// When
        /// Initialising `URLEncodedBase64` with the byte array.
        let result = URLEncodedBase64(bytes: emptyByteArray)

        /// Then
        /// The initialisation should fail.
        assert(result == nil, "Expected nil for empty byte array.")
    }
    
    @Test("Decoding invalid Base64URL string throws dataCorruptedError.")
    func testInvalidBase64URLDecodingThrowsError() {
        /// Given
        /// An invalid JSON string that is not a valid Base64URL-encoded value.
        let jsonString = "\"\""
        let jsonData = jsonString.data(using: .utf8)!

        /// When & Then
        /// Decoding should throw a dataCorruptedError.
        let decoder = JSONDecoder()
        do {
            let _ = try decoder.decode(URLEncodedBase64.self, from: jsonData)
            assert(false, "Expected decoding to throw a dataCorruptedError, but it did not.")
        } catch let DecodingError.dataCorrupted(context) {
            assert(context.debugDescription == "Invalid raw value: \("")", "Unexpected debug description: \(context.debugDescription)")
        } catch {
            assert(false, "Expected a DecodingError.dataCorruptedError, but received a different error: \(error).")
        }
    }
}
