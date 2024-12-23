//
//  EncodedBase64Tests.swift
//  base64-swift
//
//  Created by Robert Nash on 23/12/2024.
//

import Foundation
import Testing

@testable import Base64Swift

@Suite("EncodedBase64 Tests")
struct EncodedBase64Tests {
    
    @Test("Tests that a correctly formatted Base64 string is properly initialised into an EncodedBase64 instance.")
    func testInitialisationWithValidBase64() {
        /// Given
        /// A valid Base64 string.
        let validBase64 = "SGVsbG8gd29ybGQ="

        /// When
        /// Initialising `EncodedBase64` with the string.
        let result = EncodedBase64(rawValue: validBase64)

        /// Then
        /// The initialisation succeeds.
        assert(result != nil, "Expected a non-nil result for valid Base64 initialisation.")
        assert(result?.rawValue == validBase64, "Expected the rawValue to match the input Base64 string.")
    }
    
    @Test("Raw string input is encoded to Base64.")
    func testRawStringInputEncoding() {
        /// Given
        /// A raw string.
        let rawString = "Hello world"

        /// When
        /// Initialising `EncodedBase64` with the raw string.
        let result = EncodedBase64(rawValue: rawString)

        /// Then
        /// The initialisation succeeds and encodes the raw string to Base64.
        let expectedBase64 = "SGVsbG8gd29ybGQ="
        assert(result != nil, "Expected non-nil for raw string input.")
        assert(result?.rawValue == expectedBase64, "Expected the rawValue to be the Base64-encoded representation of the raw string.")
    }
    
    @Test("Non-UTF-8 convertible string fails initialisation.")
    func testNonUTF8ConvertibleString() {
        /// Given
        /// A string with invalid UTF-8 sequences.
        let invalidUTF8 = String(bytes: [0xC0, 0x80], encoding: .utf8) // Invalid UTF-8

        /// When
        /// Initialising `EncodedBase64` with the string.
        let result = EncodedBase64(rawValue: invalidUTF8 ?? "")

        /// Then
        /// The initialisation fails.
        assert(result == nil, "Expected nil for non-UTF-8 convertible string.")
    }
    
    @Test("Empty string input fails initialisation")
    func testEmptyStringInput() {
        /// Given
        /// An empty string.
        let emptyString = ""

        /// When
        /// Initialising `EncodedBase64` with the string.
        let result = EncodedBase64(rawValue: emptyString)

        /// Then
        /// The initialisation fails.
        assert(result == nil, "Expected nil for empty string input.")
    }
    
    @Test("Tests that raw binary data is correctly encoded into a valid Base64 string.")
    func testEncodingData() {
        /// Given
        /// A `Data` object with raw binary content.
        let rawData = "Hello world".data(using: .utf8)!

        /// When
        /// Initialising `EncodedBase64` with the data.
        let result = EncodedBase64(data: rawData)

        /// Then
        /// The initialisation succeeds and produces the correct Base64 string.
        assert(result != nil, "Expected a non-nil result for data encoding.")
        assert(result?.rawValue == "SGVsbG8gd29ybGQ=", "Expected the rawValue to match the Base64-encoded string of the input data.")
    }
    
    @Test("Tests that a Base64-encoded string is correctly decoded into its original byte representation.")
    func testDecodingToBytes() {
        /// Given
        /// A valid Base64 string.
        let validBase64 = "SGVsbG8gd29ybGQ="

        /// And
        /// An `EncodedBase64` instance initialised with the string.
        let encoded = EncodedBase64(rawValue: validBase64)!

        /// When
        /// Accessing the `bytes` property.
        let resultBytes = encoded.bytes

        /// Then
        /// The bytes match the original data.
        let expectedBytes = Array("Hello world".utf8)
        assert(resultBytes == expectedBytes, "Expected the bytes to match the decoded content of the Base64 string.")
    }
    
    @Test("Tests that an empty byte array fails to initialise an EncodedBase64 instance.")
    func testInitialisationWithEmptyBytes() {
        /// Given
        /// An empty byte array.
        let emptyBytes: [UInt8] = []

        /// When
        /// Initialising `EncodedBase64` with the byte array.
        let result = EncodedBase64(bytes: emptyBytes)

        /// Then
        /// The initialisation fails.
        assert(result == nil, "Expected a nil result for initialisation with an empty byte array.")
    }
    
    @Test("Tests that a Base64 string is correctly converted to a Base64URL string by removing padding.")
    func testBase64ToBase64URLConversion() {
        /// Given
        /// A valid Base64 string.
        let validBase64 = "SGVsbG8gd29ybGQ="

        /// And
        /// An `EncodedBase64` instance initialised with the string.
        let encoded = EncodedBase64(rawValue: validBase64)!

        /// When
        /// Accessing the `urlEncoded` property.
        let result = encoded.urlEncoded

        /// Then
        /// The result matches the expected Base64URL format.
        assert(result.rawValue == "SGVsbG8gd29ybGQ", "Expected the URL-encoded Base64 to match the expected format without padding.")
    }
    
    @Test("Tests that a Base64URL-encoded string is correctly initialised into an EncodedBase64 instance and restores padding.")
    func testDecodingFromBase64URLString() throws {
        /// Given
        /// A valid Base64URL-encoded string.
        let urlEncoded = "SGVsbG8gd29ybGQ"

        /// And
        /// A `URLEncodedBase64` instance initialised with the string.
        let urlBase64 = try #require(URLEncodedBase64(rawValue: urlEncoded))

        /// When
        /// Initialising a `EncodedBase64` from the Base64URL representation.
        let encoded = EncodedBase64(urlEncoded: urlBase64)

        /// Then
        /// The Base64 value matches the original string with padding added.
        assert(encoded.rawValue == "SGVsbG8gd29ybGQ=", "Expected the Base64 value to match the padded version of the Base64URL string.")
    }
    
    @Test("Base64 string with whitespace and newlines.")
    func testBase64WithWhitespaceAndNewlines() {
        /// Given
        /// An invalid base64 string
        let base64WithWhitespace = "SGVsbG8gd29y bGQ="
        let base64WithNewlines = "SGVsbG8gd29y\nbGQ="
        let base64WithInvalidCharacters = "SGVsbG8g*29ybGQ="
        let base64WithMissingPadding = "SGVsbG8gd29ybGQ"
        /// When
        /// Initialising `EncodedBase64` with each string.
        let resultWhitespace = EncodedBase64(rawValue: base64WithWhitespace)
        let resultNewlines = EncodedBase64(rawValue: base64WithNewlines)
        let resultInvalidChars = EncodedBase64(rawValue: base64WithInvalidCharacters)
        let resultInvalidPadding = EncodedBase64(rawValue: base64WithMissingPadding)

        /// Then
        /// The initialisation succeeds.
        let message = "Expected a result for invalid Base64 string. The value is simply treated as a string. The onus is on you to validate the provided data."
        assert(resultWhitespace?.rawValue == "U0dWc2JHOGdkMjl5IGJHUT0=", message)
        assert(resultNewlines?.rawValue == "U0dWc2JHOGdkMjl5CmJHUT0=", message)
        assert(resultInvalidChars?.rawValue == "U0dWc2JHOGcqMjl5YkdRPQ==", message)
        assert(resultInvalidPadding?.rawValue == "U0dWc2JHOGdkMjl5YkdR", message)
    }
    
    @Test("Encoding non-ASCII characters to Base64.")
    func testEncodingNonASCIICharacters() {
        /// Given
        /// A `Data` object containing non-ASCII characters.
        let nonASCIIString = "こんにちは世界" // "Hello World" in Japanese
        let rawData = nonASCIIString.data(using: .utf8)!

        /// When
        /// Encoding the data into Base64.
        let result = EncodedBase64(data: rawData)

        /// Then
        /// The Base64 representation matches the expected encoded value.
        let expectedBase64 = rawData.base64EncodedString()
        assert(result?.rawValue == expectedBase64, "Expected the Base64-encoded string to match the UTF-8 input data.")
    }
    
    @Test("Valid Base64 input is accepted as-is")
    func testValidBase64Input() {
        /// Given
        /// A valid Base64 string.
        let validBase64 = "SGVsbG8gd29ybGQ="

        /// When
        /// Initialising `EncodedBase64` with the string.
        let result = EncodedBase64(rawValue: validBase64)

        /// Then
        /// The initialisation succeeds and the rawValue matches the input.
        assert(result != nil, "Expected non-nil for valid Base64 input.")
        assert(result?.rawValue == validBase64, "Expected the rawValue to match the input Base64 string.")
    }
    
    @Test("Initialisation with empty string.")
    func testRawValueInitialisationWithEmptyString() {
        /// Given
        /// An empty string.
        let emptyString = ""

        /// When
        /// Initialising `EncodedBase64` with the string.
        let result = EncodedBase64(rawValue: emptyString)

        /// Then
        /// The initialisation fails.
        assert(result == nil, "Expected nil for empty string input.")
    }
        
    @Test("Initialisation with valid Base64 string.")
    func testRawValueInitialisationWithValidBase64() {
        /// Given
        /// A valid Base64 string.
        let validBase64 = "SGVsbG8gd29ybGQ="

        /// When
        /// Initialising `EncodedBase64` with the string.
        let result = EncodedBase64(rawValue: validBase64)

        /// Then
        /// The initialisation succeeds and retains the value.
        assert(result != nil, "Expected non-nil for valid Base64 string input.")
        assert(result?.rawValue == validBase64, "Expected rawValue to match the input Base64 string.")
    }
    
    @Test("Decoding valid Base64 string.")
    func testDecodingValidBase64String() {
        /// Given
        /// A valid JSON string with Base64 content.
        let jsonString = "\"SGVsbG8gd29ybGQ=\""
        let jsonData = jsonString.data(using: .utf8)!

        /// When
        /// Decoding the JSON string into an `EncodedBase64` object.
        let decoder = JSONDecoder()
        let result = try? decoder.decode(EncodedBase64.self, from: jsonData)

        /// Then
        /// Decoding succeeds and retains the value.
        assert(result != nil, "Expected non-nil for valid Base64 decoding.")
        assert(result?.rawValue == "SGVsbG8gd29ybGQ=", "Expected rawValue to match the decoded Base64 string.")
    }
    
    @Test("Decoding invalid Base64 string.")
    func testDecodingInvalidBase64String() {
        /// Given
        /// An invalid JSON string with non-Base64 content.
        let jsonString = "\"\""
        let jsonData = jsonString.data(using: .utf8)!

        /// When & Then
        /// Decoding should throw a `dataCorruptedError`.
        let decoder = JSONDecoder()
        do {
            let _ = try decoder.decode(EncodedBase64.self, from: jsonData)
            assert(false, "Expected decoding to throw a `dataCorruptedError`, but it did not.")
        } catch let DecodingError.dataCorrupted(context) {
            assert(context.debugDescription == "Invalid raw value: \("")", "Unexpected debug description: \(context.debugDescription)")
        } catch {
            assert(false, "Expected a `DecodingError.dataCorrupted`, but got \(error).")
        }
    }
    
    @Test("Encoding Base64 string.")
    func testEncodingBase64String() {
        /// Given
        /// A valid `EncodedBase64` object.
        let base64 = EncodedBase64(rawValue: "SGVsbG8gd29ybGQ=")

        /// When
        /// Encoding the object into JSON.
        let encoder = JSONEncoder()
        let encodedData = try? encoder.encode(base64)

        /// Then
        /// Encoding succeeds and produces the correct JSON string.
        let expectedJSONString = "\"SGVsbG8gd29ybGQ=\""
        let resultJSONString = encodedData.flatMap { String(data: $0, encoding: .utf8) }
        assert(resultJSONString == expectedJSONString, "Expected JSON string to match the Base64 string.")
    }
}
