//
//  Item+Convenience.swift
//  ShoppingList
//
//  Created by Zachary Frew on 7/13/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import Foundation
import CoreData

extension Item {
    
    convenience init(name: String, hasBeenPurchased: Bool = false, timeStamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
        self.hasBeenPurchased = hasBeenPurchased
        self.timeStamp = timeStamp
    }
    
}
