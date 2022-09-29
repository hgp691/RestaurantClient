//
//  RCNetworkProviderTests.swift
//  RestaurantClientTests
//
//  Created by Horacio Parra Rodriguez on 28/09/22.
//

import XCTest
@testable import RestaurantClient

final class RCNetworkProviderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        URLProtocolMock.requestHandler = nil
    }
    
    private func getMockURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolMock.self]
        let urlSession = URLSession(configuration: configuration)
        return urlSession
    }
    
    func test_RCNetworkProvider_ErrorThrowingErrorFromServer() {
        // Given
        let expectedError = RCNetworkErrorMock.serverError
        let route = RCNetworkRouteMock(url: URL(string: "https://www.thefork.com")!)
        let urlSession = getMockURLSession()
        let networkProvider = RCNetworkProvider(urlSession: urlSession)
        URLProtocolMock.requestHandler = { request in
            throw expectedError
        }
        let expectation = XCTestExpectation(description: "RCNetworkProvider_ErrorThrowingErrorFromServer")
        // When
        networkProvider.requestGET(route) { (result: Result<String, Error>) in
            switch result {
                case .failure(let error as RCNetworkErrorMock):
                    XCTAssertEqual(error, expectedError)
                    expectation.fulfill()
                default:
                    return
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_RCNetworkProvider_ErrorNoData() {
        // Given
        let expectedError = RCNetworkProviderError.noDataOrResponse
        let route = RCNetworkRouteMock(url: URL(string: "https://www.thefork.com")!)
        let urlSession = getMockURLSession()
        let networkProvider = RCNetworkProvider(urlSession: urlSession)
        URLProtocolMock.requestHandler = { request in
            let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)! 
            return (httpResponse, nil)
        }
        let expectation = XCTestExpectation(description: "RCNetworkProvider_ErrorNoData")
        // When
        networkProvider.requestGET(route) { (result: Result<String, Error>) in
            switch result {
                case .failure(let error as RCNetworkProviderError):
                    XCTAssertEqual(error, expectedError)
                    expectation.fulfill()
                default:
                    return
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_RCNetworkProvider_ErrorDecodingError() {
        // Given
        let expectedError = RCNetworkProviderError.decodingError
        let route = RCNetworkRouteMock(url: URL(string: "https://www.thefork.com")!)
        let urlSession = getMockURLSession()
        let networkProvider = RCNetworkProvider(urlSession: urlSession)
        URLProtocolMock.requestHandler = { request in
            let responseObject = ["testKey": "testValue"]
            let responseData = try! JSONEncoder().encode(responseObject)
            let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (httpResponse, responseData)
        }
        let expectation = XCTestExpectation(description: "RCNetworkProvider_ErrorDecodingError")
        // When
        networkProvider.requestGET(route) { (result: Result<Int, Error>) in
            switch result {
                case .failure(let error as RCNetworkProviderError):
                    XCTAssertEqual(error, expectedError)
                    expectation.fulfill()
                default:
                    return
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_RCNetworkProvider_ErrorSomethingHappend() {
        // Given
        let expectedCode = 490
        let expectedError = RCNetworkProviderError.somethingHappend(expectedCode)
        let route = RCNetworkRouteMock(url: URL(string: "https://www.thefork.com")!)
        let urlSession = getMockURLSession()
        let networkProvider = RCNetworkProvider(urlSession: urlSession)
        URLProtocolMock.requestHandler = { request in
            let responseObject = ["testKey": "testValue"]
            let responseData = try! JSONEncoder().encode(responseObject)
            let httpResponse = HTTPURLResponse(url: request.url!, statusCode: expectedCode, httpVersion: nil, headerFields: nil)!
            return (httpResponse, responseData)
        }
        let expectation = XCTestExpectation(description: "RCNetworkProvider_ErrorSomethingHappend")
        // When
        networkProvider.requestGET(route) { (result: Result<Int, Error>) in
            switch result {
                case .failure(let error as RCNetworkProviderError):
                    XCTAssertEqual(error, expectedError)
                    expectation.fulfill()
                default:
                    return
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_RCNetworkProvider_Success() {
        // Given
        let route = RCNetworkRouteMock(url: URL(string: "https://www.thefork.com")!)
        let urlSession = getMockURLSession()
        let networkProvider = RCNetworkProvider(urlSession: urlSession)
        URLProtocolMock.requestHandler = { request in
            let responseObject = ["testKey": "testValue"]
            let responseData = try! JSONEncoder().encode(responseObject)
            let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (httpResponse, responseData)
        }
        let expectation = XCTestExpectation(description: "RCNetworkProvider_Success")
        // When
        networkProvider.requestGET(route) { (result: Result<[String: String], Error>) in
            switch result {
                case .success(let dictionary):
                    XCTAssertEqual(dictionary["testKey"], "testValue")
                    expectation.fulfill()
                default:
                    return
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }

}

extension RCNetworkProviderError: Equatable {
    
    public static func == (lhs: RCNetworkProviderError, rhs: RCNetworkProviderError) -> Bool {
        switch (lhs, rhs) {
            case (.noDataOrResponse, .noDataOrResponse):
                return true
            case (.somethingHappend(let lhsCode), .somethingHappend(let rhsCode)):
                return lhsCode == rhsCode
            case (.decodingError, .decodingError):
                return true
            default:
                return false
        }
    }
}

fileprivate enum RCNetworkErrorMock: Error {
    case serverError
}

fileprivate struct RCNetworkRouteMock: RCNetworkRouteProtocol {
    
    var url: URL?
    
    func buildURL() -> URL {
        if let url {
            return url
        }
        
        fatalError("Not implemented")
    }
}

fileprivate class URLProtocolMock: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        guard let requestHandler = Self.requestHandler else {
            fatalError("You must provide a implementation to mock")
        }
        
        do {
            let (response, data) = try requestHandler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        
    }
}
