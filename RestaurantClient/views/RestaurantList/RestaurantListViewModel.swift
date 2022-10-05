//
//  RestaurantListViewModel.swift
//  RestaurantClient
//
//  Created by Horacio Parra Rodriguez on 3/10/22.
//

import Foundation

public enum SortOption {
    case name
    case rating
}

public protocol RestaurantListViewModelProtocol {
    var showError: ((Error) -> Void)? { get set }
    var reloadData: (() -> Void)? { get set }
    
    var restaurantCount: Int { get }
    
    func start()
    func getCellViewModel(indexPath: IndexPath) -> RestaurantListCellViewModel
    func setSortOption(_ sortOption: SortOption)
}

public final class RestaurantListViewModel: RestaurantListViewModelProtocol {
    
    let restaurantDataManager: RestaurantListDataManagerProtocol
    
    init(restaurantDataManager: RestaurantListDataManagerProtocol = RestaurantListDataManager()) {
        self.restaurantDataManager = restaurantDataManager
    }
    
    private var sortOption: SortOption = .name
    private(set) var restaurants: [Restaurant] = []
    
    public var showError: ((Error) -> Void)?
    public var reloadData: (() -> Void)?
    
    
    public var restaurantCount: Int {
        restaurants.count
    }
    
    public func start() {
        restaurantDataManager.getRestaurantList { [weak self] (result: Result<[Restaurant], Error>) in
            switch result {
                case .success(let restaurants):
                    self?.restaurants = restaurants
                    self?.sortRestaurants()
                    self?.reloadData?()
                case .failure(let error):
                    self?.showError?(error)
            }
        }
    }
    
    public func getCellViewModel(indexPath: IndexPath) -> RestaurantListCellViewModel {
        let restaurant = restaurants[indexPath.row]
        return RestaurantListCellViewModel(restaurant: restaurant)
    }
    
    public func setSortOption(_ sortOption: SortOption) {
        if sortOption != self.sortOption {
            self.sortOption = sortOption
            sortRestaurants()
            self.reloadData?()
        }
    }
    
    private func sortRestaurants() {
        switch sortOption {
            case .name:
                restaurants = restaurants.sort(by: \.name)
                break
            case .rating:
                restaurants = restaurants.sort(by: \.aggregateRatings)
                break
        }
    }
}
