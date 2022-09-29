//
//  RCNetworkProviderProtocol.swift
//  RestaurantClient
//
//  Created by Horacio Parra Rodriguez on 28/09/22.
//

import Foundation

public enum RCNetworkProviderError: Error, LocalizedError {
    
    case noDataOrResponse
    case somethingHappend(Int)
    case decodingError
    
    public var errorDescription: String? {
        switch self {
            case .noDataOrResponse:
                return "There is no data or reponse"
            case .somethingHappend(let code):
                return "Something happend. Code: \(code)"
            case .decodingError:
                return "There is a problem decoding the response of the server."
        }
    }
}

public protocol RCNetworkProviderProtocol {
    
    func requestGET<T: Decodable>(_ route: RCNetworkRouteProtocol,
                                  _ completion: @escaping (Result<T, Error>) -> Void)
}

public struct RCNetworkProvider: RCNetworkProviderProtocol {
    
    let urlSession: URLSession
    let jsonDecoder: JSONDecoder
    
    init(urlSession: URLSession = URLSession.shared, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    public func requestGET<T: Decodable >(_ route: RCNetworkRouteProtocol, _ completion: @escaping (Result<T, Error>) -> Void) {
        
        let request = URLRequest(url: route.buildURL())
        
        urlSession.dataTask(with: request) { data, response, error in
            
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data,
                  !data.isEmpty,
                  let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(RCNetworkProviderError.noDataOrResponse))
                return
            }
            
            handleResponse(data: data, httpResponse: httpResponse, completion)
            
        }
        .resume()
    }
    
    private func handleResponse<T: Decodable >(data: Data, httpResponse: HTTPURLResponse, _ completion: @escaping (Result<T, Error>) -> Void) {
        switch httpResponse.statusCode {
            case 200 ... 299:
                do {
                    let decodedObject = try jsonDecoder.decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    completion(.failure(RCNetworkProviderError.decodingError))
                }
            default:
                // TODO: - we can decode the error recived from the server
                completion(.failure(RCNetworkProviderError.somethingHappend(httpResponse.statusCode)))
        }
    }
}
