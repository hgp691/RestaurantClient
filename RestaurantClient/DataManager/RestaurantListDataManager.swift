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
    let restaurantStorage: RestaurantStorageProtocol
    
    init(networkProvider: RCNetworkProviderProtocol = RCNetworkProvider(),
         restaurantStorage: RestaurantStorageProtocol = RestaurantStorage()) {
        self.networkProvider = networkProvider
        self.restaurantStorage = restaurantStorage
    }
    
    public func getRestaurantList(_ completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        let route = RCNetworkRoute.restaurantList
        networkProvider.requestGET(route) { (result: Result<RestaurantListHelper, Error>) in
            switch result {
                case .success(let helper):
                    let restaurants = helper.data
                    saveRestaurants(restaurants: restaurants)
                    completion(.success(restaurants))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    private func saveRestaurants(restaurants: [Restaurant]) {
        restaurants.forEach { restaurantStorage.saveRestaurant(restaurant: $0) }
    }
}
