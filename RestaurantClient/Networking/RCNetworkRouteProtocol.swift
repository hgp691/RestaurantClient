//
//  RCNetworkRouteProtocol.swift
//  RestaurantClient
//
//  Created by Horacio Parra Rodriguez on 28/09/22.
//

import Foundation

public protocol RCNetworkRouteProtocol {
    
    func buildURL() -> URL
}

public enum RCNetworkRoute {
    
    case restaurantList
}

extension RCNetworkRoute: RCNetworkRouteProtocol {
    
    public func buildURL() -> URL {
        switch self {
            case .restaurantList:
                // This must never fail
                return URL(string: "https://alanflament.github.io/TFTest/test.json")!
        }
    }
}
