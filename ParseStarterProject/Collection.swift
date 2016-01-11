//
//  Collection.swift
//  ParseStarterProject
//
//  Created by Михаил on 04.05.15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Collection: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var cardsSet: NSSet
    
    func addCard(card: Card) {
        self.Cards.append(card)
    }
    
    var Cards: [Card] {
        get {
            return cardsSet.allObjects as! [Card]
        }
        
        set {
            cardsSet.setByAddingObjectsFromArray(newValue)
        }
    }
    
    class var entity: NSEntityDescription {
        return NSEntityDescription.entityForName("Collection",
            inManagedObjectContext: CoreDataHelper.instance.context)!
    }
    
    convenience init(cards: [Card], isTradeCollection: Bool) {
        
        self.init(entity: Collection.entity,
            insertIntoManagedObjectContext: CoreDataHelper.instance.context)

        self.Cards = [Card]()
        if isTradeCollection {
            name = "trade"
        }
        else {
            name = "wish"
        }
        
        self.cardsSet = arrayToSet(cards)
    }
    
    private func arrayToSet(cards: [Card]) -> NSSet {
        var set = NSSet()
        
        for card in cards {
            set = set.setByAddingObject(card)
        }
        
        return set
    }
}
