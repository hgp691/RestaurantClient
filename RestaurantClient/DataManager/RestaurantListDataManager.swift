//
//  RestaurantListDataManager.swift
//  RestaurantClient
//
//  Created by Horacio Parra Rodriguez on 28/09/22.
//

import Foundation

public protocol RestaurantListDataManagerProtocol {
    
    func getRestaurantList(_ completion: @escaping (Result<[Restaurant], Error>) -> Void)
}

public struct RestaurantListDataManager: RestaurantListDataManagerProtocol {
    
    let networkProvider: RCNetworkProviderProtocol
    
    init(networkProvider: RCNetworkProviderProtocol = RCNetworkProvider()) {
        self.networkProvider = networkProvider
    }
    
    public func getRestaurantList(_ completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        let route = RCNetworkRoute.restaurantList
        networkProvider.requestGET(route) { (result: Result<RestaurantListHelper, Error>) in
            switch result {
                case .success(let helper):
                    completion(.success(helper.data))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
