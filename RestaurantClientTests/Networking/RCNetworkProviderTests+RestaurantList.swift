//
//  RCNetworkProviderTests+RestaurantList.swift
//  RestaurantClientTests
//
//  Created by Horacio Parra Rodriguez on 28/09/22.
//

import XCTest
@testable import RestaurantClient

extension RCNetworkProviderTests {
    
    func test_RCNetworkProvider_shouldBringTheData() {
        // Given
        let route = RCNetworkRoute.restaurantList
        let urlSession = getMockURLSession()
        let networkProvider = RCNetworkProvider(urlSession: urlSession)
        URLProtocolMock.requestHandler = { request in
            let responseData = URLProtocolMock.getRestaurantListData()
            let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (httpResponse, responseData)
        }
        let expectation = XCTestExpectation(description: "RCNetworkProvider_shouldBringTheData")
        // When
        networkProvider.requestGET(route) { (result: Result<RestaurantListHelper, Error>) in
            
            switch result {
                case .success(let helper):
                    XCTAssertNotEqual(helper.data.count, 0)
                    expectation.fulfill()
                default:
                    return
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
