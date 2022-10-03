//
//  RestaurantStorage.swift
//  RestaurantClient
//
//  Created by Horacio Parra Rodriguez on 3/10/22.
//

import CoreData


public protocol RestaurantStorageProtocol {
    
    // TODO: - make the full implementation
    func saveRestaurant(restaurant: Restaurant)
    
    func setRestaurantAsFavorite(restaurant: Restaurant)
    
    func isRestaurantFavorite(restaurant: Restaurant) -> Bool
}

public struct RestaurantStorage: RestaurantStorageProtocol {
    
    enum Constants {
        static let queueLabel = "com.RestaurantStorage"
        static let entityName = "RestaurantCD"
    }
    
    let dispatchQueue: DispatchQueue
    let store: RestaurantDataStore
    
    init(store: RestaurantDataStore = RestaurantDataStore()) {
        self.dispatchQueue = DispatchQueue(label: Constants.queueLabel)
        self.store = store
    }
    
    public func saveRestaurant(restaurant: Restaurant) {
        dispatchQueue.sync {
            let context = self.store.persistanceContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
            request.predicate = NSPredicate(format: "id == %@", restaurant.uuid)
            request.returnsObjectsAsFaults = true
            guard let result = try? context.fetch(request) as? [RestaurantCD],
                  result.isEmpty else {
                return
            }
            
            let restaurantCD = RestaurantCD(context: context)
            restaurantCD.id = restaurant.uuid
            store.save()
        }
    }
    
    public func setRestaurantAsFavorite(restaurant: Restaurant) {
        dispatchQueue.sync {
            let context = self.store.persistanceContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
            request.predicate = NSPredicate(format: "id == %@", restaurant.uuid)
            request.returnsObjectsAsFaults = true
            if let result = try? context.fetch(request) as? [RestaurantCD],
               let firstSaved = result.first {
                firstSaved.isFavorite = !firstSaved.isFavorite
            }
            store.save()
        }
    }
    
    public func isRestaurantFavorite(restaurant: Restaurant) -> Bool {
        dispatchQueue.sync {
            let context = self.store.persistanceContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityName)
            request.predicate = NSPredicate(format: "id == %@", restaurant.uuid)
            request.returnsObjectsAsFaults = true
            if let result = try? context.fetch(request) as? [RestaurantCD],
               let firstSaved = result.first {
                return firstSaved.isFavorite
            }
            return false
        }
    }
    
    
}
