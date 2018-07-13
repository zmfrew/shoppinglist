//
//  File.swift
//  ShoppingList
//
//  Created by Zachary Frew on 7/13/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import Foundation
import CoreData

class ItemController {
    
    // MARK: - Singleton
    static let shared = ItemController()
        
    // MARK: - Methods
    func addItem(with name: String) {
        _ = Item(name: name)
        saveToPersistentStore()
    }
    
    func delete(item: Item) {
        CoreDataStack.context.delete(item)
        saveToPersistentStore()
    }
    
    func togglehasBeenPurchased(item: Item) {
        item.hasBeenPurchased = !item.hasBeenPurchased
        saveToPersistentStore()
    }
    
    // MARK: - Persistence
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error occured saving data: \(error.localizedDescription).")
        }
    }
    
}
