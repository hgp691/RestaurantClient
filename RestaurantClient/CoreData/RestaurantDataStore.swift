//
//  RestaurantDataStore.swift
//  RestaurantClient
//
//  Created by Horacio Parra Rodriguez on 3/10/22.
//

import CoreData

public enum StorageType {
    case disk
    case memory
}

public final class RestaurantDataStore {
    
    let persistanceContainer: NSPersistentContainer
    let storageType: StorageType
    
    init(storageType: StorageType = .disk) {
        self.storageType = storageType
        
        let bundle = Bundle(for: RestaurantDataStore.self)
        guard let mom = NSManagedObjectModel.mergedModel(from: [bundle]) else {
            fatalError()
        }
        
        self.persistanceContainer = NSPersistentContainer(name: "RestaurantContainer",
                                                          managedObjectModel: mom)
        
        if storageType == .memory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            self.persistanceContainer.persistentStoreDescriptions = [description]
        }
        
        self.persistanceContainer.loadPersistentStores { storeDescription, error in
            self.persistanceContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error {
                print("Error loading PersistentStores \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        let context = self.persistanceContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context \(error.localizedDescription)")
            }
        }
    }
}
