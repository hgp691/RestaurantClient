//
//  RestaurantListDataManagerTest.swift
//  RestaurantClientTests
//
//  Created by Horacio Parra Rodriguez on 28/09/22.
//

import XCTest
@testable import RestaurantClient

final class RestaurantListDataManagerTest: XCTestCase {
    
    var dataManager: RestaurantListDataManager!
    var networProvider: RCNetworkProviderProtocol!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: configuration)
        networProvider = RCNetworkProvider(urlSession: session)
        dataManager = RestaurantListDataManager(networkProvider: networProvider)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        dataManager = nil
        networProvider = nil
        URLProtocolMock.requestHandler = nil
    }
    
    func test_RestaurantListDataManager_getRestaurantList_Success() {
        // Given
        URLProtocolMock.requestHandler = { request in
            let responseHttp = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
            let jsonData = URLProtocolMock.getRestaurantListData()
            return (responseHttp!, jsonData)
        }
        let expectation = XCTestExpectation(description: "RestaurantListDataManager_getRestaurantList_Success")
        
        // Then
        dataManager.getRestaurantList { (result: Result<[Restaurant], Error>) in
            switch result {
                case .success( _):
                    // Then
                    expectation.fulfill()
                default:
                    break
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_RestaurantListDataManager_getRestaurantList_Error() {
        // Given
        URLProtocolMock.requestHandler = { request in
            throw RCNetworkProviderError.decodingError
        }
        let expectation = XCTestExpectation(description: "RestaurantListDataManager_getRestaurantList_Success")
        
        // Then
        dataManager.getRestaurantList { (result: Result<[Restaurant], Error>) in
            switch result {
                case .failure( _):
                    // Then
                    expectation.fulfill()
                default:
                    break
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
}

