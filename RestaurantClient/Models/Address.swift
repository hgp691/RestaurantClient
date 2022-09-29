//
//  Address.swift
//  RestaurantClient
//
//  Created by Horacio Parra Rodriguez on 28/09/22.
//

import Foundation

struct Address: Decodable {
    let street: String
    let postalCode: String
    let locality: String
    let country: String
}
