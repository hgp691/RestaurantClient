//
//  Array+Ext.swift
//  RestaurantClient
//
//  Created by Horacio Parra Rodriguez on 4/10/22.
//

import Foundation

extension Array {
    
    func sort<T: Comparable>(by keyPath: KeyPath<Element, T>, isAscending: Bool = true) -> [Element] {
        return sorted {
            let lhs = $0[keyPath: keyPath]
            let rhs = $1[keyPath: keyPath]
            return isAscending ? lhs < rhs : lhs > rhs
        }
    }
}
