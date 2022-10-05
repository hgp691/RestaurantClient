//
//  RestaurantListViewModelTests.swift
//  RestaurantClientTests
//
//  Created by Horacio Parra Rodriguez on 5/10/22.
//

import XCTest
@testable import RestaurantClient

final class RestaurantListViewModelTests: XCTestCase {
    
    var restaurantDataManagerMock: RestaurantDataManagerMock!
    var listViewModel: RestaurantListViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        restaurantDataManagerMock = RestaurantDataManagerMock()
        listViewModel = RestaurantListViewModel(restaurantDataManager: restaurantDataManagerMock)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        restaurantDataManagerMock = nil
        listViewModel = nil
    }
    
    func test_RestaurantListViewModel_DownloadDataWhenStartCalled() {
        // Given
        restaurantDataManagerMock.restaurantsToReturn = []
        // When
        listViewModel.start()
        // Then
        XCTAssertTrue(restaurantDataManagerMock.getRestaurantListCalled)
    }
    
    func test_RestaurantListViewModel_SortRestaurantsWhenStartCalled() {
        // Given
        let restaurant1 = getMock(name: "ALPHA")
        let restaurant2 = getMock(name: "HOTEL")
        let restaurant3 = getMock(name: "ZULU")
        restaurantDataManagerMock.restaurantsToReturn = [restaurant2, restaurant3, restaurant1]
        // When
        listViewModel.start()
        // Then
        XCTAssertTrue(restaurantDataManagerMock.getRestaurantListCalled)
        XCTAssertEqual(listViewModel.restaurantCount, 3)
        let expected1 = listViewModel.restaurants[0]
        let expected2 = listViewModel.restaurants[1]
        let expected3 = listViewModel.restaurants[2]
        XCTAssertEqual(expected1.name, restaurant1.name)
        XCTAssertEqual(expected2.name, restaurant2.name)
        XCTAssertEqual(expected3.name, restaurant3.name)
    }
    
    func test_RestaurantListViewModel_reloadDataCalledWhenStartCalled() {
        // Given
        restaurantDataManagerMock.restaurantsToReturn = []
        let expectation = XCTestExpectation(description: "RestaurantListViewModel_SortRestaurantsWhenStartCalled")
        listViewModel.reloadData = {
            // Then
            expectation.fulfill()
        }
        // When
        listViewModel.start()
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_RestaurantListViewModel_showErrorCalledWhenStartCalled() {
        // Given
        restaurantDataManagerMock.errorToReturn = MockError.mock
        let expectedMessage = "TestMockError"
        let expectation = XCTestExpectation(description: "RestaurantListViewModel_showErrorCalledWhenStartCalled")
        listViewModel.showError = { error in
            XCTAssertEqual(error.localizedDescription, expectedMessage)
            expectation.fulfill()
        }
        // When
        listViewModel.start()
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_RestaurantListViewModel_reloadCalledWhenSetSortOptionCalledWithName() {
        // Given
        restaurantDataManagerMock.errorToReturn = MockError.mock
        let restaurant1 = getMock(name: "ALPHA")
        let restaurant2 = getMock(name: "HOTEL")
        let restaurant3 = getMock(name: "ZULU")
        restaurantDataManagerMock.restaurantsToReturn = [restaurant2, restaurant3, restaurant1]
        listViewModel.start()
        let expectation = XCTestExpectation(description: "RestaurantListViewModel_reloadCalledWhenSetSortOptionCalled")
        expectation.isInverted = true
        listViewModel.reloadData = {
            expectation.fulfill()
        }
        // When
        listViewModel.setSortOption(.name)
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_RestaurantListViewModel_reloadCalledWhenSetSortOptionCalledWithRating() {
        // Given
        restaurantDataManagerMock.errorToReturn = MockError.mock
        let restaurant1 = getMock(name: "ALPHA", theForkRating: Rating(ratingValue: 0.0, reviewCount: 100))
        let restaurant2 = getMock(name: "HOTEL", theForkRating: Rating(ratingValue: 50.0, reviewCount: 100))
        let restaurant3 = getMock(name: "ZULU", theForkRating: Rating(ratingValue: 100.0, reviewCount: 100))
        restaurantDataManagerMock.restaurantsToReturn = [restaurant2, restaurant3, restaurant1]
        listViewModel.start()
        let expectation = XCTestExpectation(description: "RestaurantListViewModel_reloadCalledWhenSetSortOptionCalledWithRating")
        listViewModel.reloadData = {
            // Then
            XCTAssertEqual(self.listViewModel.restaurants[0].aggregateRatings.thefork.ratingValue, 0.0)
            XCTAssertEqual(self.listViewModel.restaurants[1].aggregateRatings.thefork.ratingValue, 50.0)
            XCTAssertEqual(self.listViewModel.restaurants[2].aggregateRatings.thefork.ratingValue, 100.0)
            expectation.fulfill()
        }
        // When
        listViewModel.setSortOption(.rating)
        wait(for: [expectation], timeout: 2.0)
    }
    
    private func getMock(name: String? = nil, theForkRating: Rating? = nil) -> Restaurant {
        let localRating = theForkRating ?? Rating(ratingValue: 50.0, reviewCount: 50)
        let localName = name ?? "TestName"
        let address = Address(street: "", postalCode: "", locality: "", country: "")
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

fileprivate enum MockError: Error, LocalizedError {
    case mock
    
    var errorDescription: String? {
        switch self {
            case .mock:
                return "TestMockError"
        }
    }
}

final class RestaurantDataManagerMock: RestaurantListDataManagerProtocol {
    
    var restaurantsToReturn: [Restaurant]?
    var errorToReturn: Error?
    var getRestaurantListCalled = false
    
    func getRestaurantList(_ completion: @escaping (Result<[RestaurantClient.Restaurant], Error>) -> Void) {
        
        getRestaurantListCalled = true
        
        if let restaurantsToReturn {
            completion(.success(restaurantsToReturn))
            return
        }
        if let errorToReturn {
            completion(.failure(errorToReturn))
            return
        }
    }
}

