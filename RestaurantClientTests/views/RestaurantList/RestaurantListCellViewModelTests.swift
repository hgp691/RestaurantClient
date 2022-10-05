//
//  RestaurantListCellViewModelTests.swift
//  RestaurantClientTests
//
//  Created by Horacio Parra Rodriguez on 5/10/22.
//

import XCTest
@testable import RestaurantClient

final class RestaurantListCellViewModelTests: XCTestCase {
    
    var viewModel: RestaurantListCellViewModel!
    var restaurant: Restaurant!
    var restaurantStorage: RestaurantStorageMock2!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        restaurant = getMock(name: "TheMock", theForkRating: Rating(ratingValue: 50.0, reviewCount: 50))
        restaurantStorage = RestaurantStorageMock2()
        viewModel = RestaurantListCellViewModel(restaurant: restaurant, restaurantStorage: restaurantStorage)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        restaurant = nil
        restaurantStorage = nil
        viewModel = nil
    }
    
    func test_RestaurantListCellViewModel_info() {
        // When
        let urlString = viewModel.mainImageUrlString
        let titleString = viewModel.titleString
        let ratingString = viewModel.ratingString
        let addressString = viewModel.addressString
        // Then
        XCTAssertEqual(urlString, "")
        XCTAssertEqual(titleString, "TheMock")
        XCTAssertEqual(ratingString, "50.0")
        //address.street + ", " + address.locality + " - " + address.country
        XCTAssertEqual(addressString, "testStreet, testLocality - testCountry")
    }
    
    func test_RestaurantListCellViewModel_FavoriteImageName_WhenIsFavorite() {
        // Given
        restaurantStorage.isFavoriteToReturn = true
        // When
        let imageName = viewModel.favoriteImageName
        // Then
        XCTAssertEqual(imageName, "filled-heart")
    }
    
    func test_RestaurantListCellViewModel_FavoriteImageName_WhenIsNOTFavorite() {
        // Given
        restaurantStorage.isFavoriteToReturn = false
        // When
        let imageName = viewModel.favoriteImageName
        // Then
        XCTAssertEqual(imageName, "empty-heart")
    }
    
    func test_RestaurantListCellViewModel_FavoriteImageName_SetFavorite() {
        // When
        viewModel.setFavorite()
        // Then
        XCTAssertTrue(restaurantStorage.setRestaurantAsFavoriteCalled)
    }
    
    
    private func getMock(name: String? = nil, theForkRating: Rating? = nil) -> Restaurant {
        let localRating = theForkRating ?? Rating(ratingValue: 50.0, reviewCount: 50)
        let localName = name ?? "TestName"
        let address = Address(street: "testStreet", postalCode: "testPostalCode", locality: "testLocality", country: "testCountry")
        let aggregateRatings = AggregateRatings(thefork: localRating, tripadvisor: localRating)
        let offer = Offer(name: "", label: "")
        let restaurant = Restaurant(name: localName,
                                    uuid: "TestId",
                                    servesCuisine: "",
                                    priceRange: 0,
                                    currenciesAccepted: "",
                                    address: address,
                                    aggregateRatings: aggregateRatings,
                                    mainPhoto: nil,
                                    bestOffer: offer)
        return restaurant
    }

}

final class RestaurantStorageMock2: RestaurantStorageProtocol {
    
    public var isFavoriteToReturn = false
    
    var setRestaurantAsFavoriteCalled = false
    
    func saveRestaurant(restaurant: RestaurantClient.Restaurant) { }
    
    func setRestaurantAsFavorite(restaurant: RestaurantClient.Restaurant) {
        setRestaurantAsFavoriteCalled = true
    }
    
    func isRestaurantFavorite(restaurant: RestaurantClient.Restaurant) -> Bool {
        return isFavoriteToReturn
    }
}
