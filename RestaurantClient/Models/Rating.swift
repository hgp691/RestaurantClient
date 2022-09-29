//
//  Rating.swift
//  RestaurantClient
//
//  Created by Horacio Parra Rodriguez on 28/09/22.
//

import Foundation

struct Rating: Decodable {
    let ratingValue: Double
    let reviewCount: Int
}
