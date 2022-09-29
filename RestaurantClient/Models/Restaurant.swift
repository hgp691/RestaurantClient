//
//  Restaurant.swift
//  RestaurantClient
//
//  Created by Horacio Parra Rodriguez on 28/09/22.
//

import Foundation

public struct RestaurantListHelper: Decodable {
    let data: [Restaurant]
}

public struct Restaurant: Decodable {
    
    let name: String
    let uuid: String
    let servesCuisine: String
    let priceRange: Int
    let currenciesAccepted: String
    let address: Address
    let aggregateRatings: AggregateRatings
    let mainPhoto: [String: String]?
    let bestOffer: Offer
}
