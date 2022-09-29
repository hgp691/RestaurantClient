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
