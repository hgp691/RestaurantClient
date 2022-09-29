//
//  RCNetworkRouteTests.swift
//  RestaurantClientTests
//
//  Created by Horacio Parra Rodriguez on 28/09/22.
//

import XCTest
@testable import RestaurantClient

final class RCNetworkRouteTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_RCNetworkRoute_BuildUrlRestaurantList() {
        // Given
        let route = RCNetworkRoute.restaurantList
        // When
        let url = route.buildURL()
        // Then
        XCTAssertEqual("https://alanflament.github.io/TFTest/test.json", url.absoluteString)
    }

}
