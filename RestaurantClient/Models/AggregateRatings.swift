//
//  AggregateRatings.swift
//  RestaurantClient
//
//  Created by Horacio Parra Rodriguez on 28/09/22.
//

import Foundation

struct AggregateRatings: Decodable {
    let thefork: Rating
    let tripadvisor: Rating
}

extension AggregateRatings: Comparable {
    
    static func < (lhs: AggregateRatings, rhs: AggregateRatings) -> Bool {
        return lhs.thefork.ratingValue < rhs.thefork.ratingValue
    }
    
    static func == (lhs: AggregateRatings, rhs: AggregateRatings) -> Bool {
        return lhs.thefork.ratingValue == rhs.thefork.ratingValue
    }
}
