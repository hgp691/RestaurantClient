//
//  RCNetworkProviderErrorTests.swift
//  RestaurantClientTests
//
//  Created by Horacio Parra Rodriguez on 28/09/22.
//

import XCTest
@testable import RestaurantClient

final class RCNetworkProviderErrorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_RCNetworkProviderError_noDataOrResponseDescription() {
        // Given
        let error = RCNetworkProviderError.noDataOrResponse
        // When
        let message = error.localizedDescription
        // Then
        XCTAssertEqual(message, "There is no data or reponse")
    }

    func test_RCNetworkProviderError_somethingHappendDescription() {
        // Given
        let error = RCNetworkProviderError.somethingHappend(340)
        // When
        let message = error.localizedDescription
        // Then
        XCTAssertEqual(message, "Something happend. Code: 340")
    }

    func test_RCNetworkProviderError_decodingErrorDescription() {
        // Given
        let error = RCNetworkProviderError.decodingError
        // When
        let message = error.localizedDescription
        // Then
        XCTAssertEqual(message, "There is a problem decoding the response of the server.")
    }
    
}
