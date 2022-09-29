//
//  URLProtocolMock.swift
//  RestaurantClientTests
//
//  Created by Horacio Parra Rodriguez on 28/09/22.
//

import Foundation

final class URLProtocolMock: URLProtocol {
    
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

extension URLProtocolMock {
    
    public static func getRestaurantListData() -> Data? {
        let fileName = "ServerResponseMock"
        let bundle = Bundle(for: RCNetworkProviderTests.self)
        
        if let path = bundle.path(forResource: fileName, ofType: "json"),
           let jsonData = try? String(contentsOfFile: path).data(using: .utf8) {
            return jsonData
        }
        
        return nil
        
    }
}
