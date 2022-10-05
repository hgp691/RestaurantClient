//
//  RestaurantListCellViewModel.swift
//  RestaurantClient
//
//  Created by Horacio Parra Rodriguez on 3/10/22.
//

import Foundation

public protocol RestaurantListCellViewModelProtocol {
    
    var mainImageUrlString: String { get }
    var titleString: String { get }
    var ratingString: String { get }
    var addressString: String { get }
    var favoriteImageName: String { get }
    
    func setFavorite()
}

final public class RestaurantListCellViewModel: RestaurantListCellViewModelProtocol {
    
    public enum PhotoSizeKeys: String, Decodable {
        case source = "source"
    }
    
    private let restaurant: Restaurant
    private let restaurantStorage: RestaurantStorageProtocol
    
    public var mainImageUrlString: String {
        restaurant.mainPhoto?[PhotoSizeKeys.source.rawValue] ?? ""
    }
    
    public var titleString: String {
        restaurant.name
    }
    
    public var ratingString: String {
        "\(restaurant.aggregateRatings.thefork.ratingValue)"
    }
    
    public var addressString: String {
        let address = restaurant.address
        return address.street + ", " + address.locality + " - " + address.country
    }
    
    public var favoriteImageName: String {
        restaurantStorage.isRestaurantFavorite(restaurant: restaurant) ? "filled-heart" : "empty-heart"
    }
    
    init(restaurant: Restaurant, restaurantStorage: RestaurantStorageProtocol = RestaurantStorage()) {
        self.restaurant = restaurant
        self.restaurantStorage = restaurantStorage
    }
    
    public func setFavorite() {
        restaurantStorage.setRestaurantAsFavorite(restaurant: restaurant)
    }
}
