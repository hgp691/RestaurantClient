//
//  RestaurantStorageTests.swift
//  RestaurantClientTests
//
//  Created by Horacio Parra Rodriguez on 3/10/22.
//

import XCTest
import CoreData
@testable import RestaurantClient

final class RestaurantStorageTests: XCTestCase {
    
    var restaurantStorage: RestaurantStorage!
    var dataStore: RestaurantDataStore!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataStore = RestaurantDataStore(storageType: .memory)
        restaurantStorage = RestaurantStorage(store: dataStore)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        restaurantStorage = nil
        dataStore = nil
    }

    func test_RestaurantStorage_saveRestaurant() {
        // Given
        let expectedUUID = "expectedUUID"
        let restaurant = getRestaurantMock(uuid: expectedUUID)
        // When
        restaurantStorage.saveRestaurant(restaurant: restaurant)
        // Then
        let allRestaurants = getAllRestaurantsCD()
        XCTAssertEqual(allRestaurants.count, 1)
        XCTAssertEqual(allRestaurants.first!.id, expectedUUID)
        XCTAssertFalse(allRestaurants.first!.isFavorite)
    }
    
    func test_RestaurantStorage_saveRestaurant_doesntSaveDuplicates() {
        // Given
        let expectedUUID = "expectedUUID"
        let restaurant1 = getRestaurantMock(uuid: expectedUUID)
        let restaurant2 = getRestaurantMock(uuid: expectedUUID)
        // When
        restaurantStorage.saveRestaurant(restaurant: restaurant1)
        restaurantStorage.saveRestaurant(restaurant: restaurant2)
        // Then
        let allRestaurants = getAllRestaurantsCD()
        XCTAssertEqual(allRestaurants.count, 1)
        XCTAssertEqual(allRestaurants.first!.id, expectedUUID)
        XCTAssertFalse(allRestaurants.first!.isFavorite)
    }
    
    func test_RestaurantStorage_setRestaurantFavorite_WhenFalse() {
        // Given
        let expectedUUID = "expectedUUID"
        let restaurant1 = getRestaurantMock(uuid: expectedUUID)
        restaurantStorage.saveRestaurant(restaurant: restaurant1)
        let allRestaurants = getAllRestaurantsCD()
        XCTAssertFalse(allRestaurants.first!.isFavorite)
        // When
        restaurantStorage.setRestaurantAsFavorite(restaurant: restaurant1)
        // Then
        let allRestaurants2 = getAllRestaurantsCD()
        XCTAssertTrue(allRestaurants2.first!.isFavorite)
    }
    
    func test_RestaurantStorage_setRestaurantFavorite_WhenTrue() {
        // Given
        let expectedUUID = "expectedUUID"
        let restaurant1 = getRestaurantMock(uuid: expectedUUID)
        restaurantStorage.saveRestaurant(restaurant: restaurant1)
        let allRestaurants = getAllRestaurantsCD()
        XCTAssertFalse(allRestaurants.first!.isFavorite)
        restaurantStorage.setRestaurantAsFavorite(restaurant: restaurant1)
        // When
        restaurantStorage.setRestaurantAsFavorite(restaurant: restaurant1)
        // Then
        let allRestaurants2 = getAllRestaurantsCD()
        XCTAssertFalse(allRestaurants2.first!.isFavorite)
    }
    
    func test_RestaurantStorage_isFavorite() {
        // Given
        let expectedUUID = "expectedUUID"
        let restaurant1 = getRestaurantMock(uuid: expectedUUID)
        restaurantStorage.saveRestaurant(restaurant: restaurant1)
        restaurantStorage.setRestaurantAsFavorite(restaurant: restaurant1)
        // When
        var isFavorite = restaurantStorage.isRestaurantFavorite(restaurant: restaurant1)
        // Then
        XCTAssertTrue(isFavorite)
        
        // Given2
        restaurantStorage.setRestaurantAsFavorite(restaurant: restaurant1)
        // When2
        isFavorite = restaurantStorage.isRestaurantFavorite(restaurant: restaurant1)
        // Then2
        XCTAssertFalse(isFavorite)
    }
    
}

extension RestaurantStorageTests {
    
    private func getAllRestaurantsCD() -> [RestaurantCD] {
        let context = dataStore.persistanceContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RestaurantCD")
        if let result = try? context.fetch(request) as? [RestaurantCD] {
            return result
        }
        fatalError()
    }
    
    private func getRestaurantMock(uuid: String) -> Restaurant {
        
        let address = Address(street: "testStreet", postalCode: "testPostaCode", locality: "testLocality", country: "testCountry")
        
        let rating = Rating(ratingValue: 100, reviewCount: 20000)
        
        let aggregateRating = AggregateRatings(thefork: rating, tripadvisor: rating)
        
        let offer = Offer(name: "testOffer", label: "testLabel")
        
        let restaurant = Restaurant(name: "testName",
                                    uuid: uuid,
                                    servesCuisine: "testServesCuisine",
                                    priceRange: 20,
                                    currenciesAccepted: "COP",
                                    address: address,
                                    aggregateRatings: aggregateRating,
                                    mainPhoto: nil,
                                    bestOffer: offer)
        
        return restaurant
    }
}
