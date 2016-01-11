//
//  Person.swift
//  ParseStarterProject
//
//  Created by Михаил on 04.05.15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse

enum UserCollectionType {
    case Trade
    case Wish
}

class User: PFUser {

    @NSManaged var name: String
    @NSManaged var phone: String
    @NSManaged var city: String
    
    var tradeCards: AnyObject? {
        get {
            return self["tradeCards"]
        }
        set {
            self["tradeCards"] = newValue
            self.tradeCodes = [String]()
            for key in self.tradeCards as! [String : Int] {
                self.tradeCodes.append(key.0)
            }
            self.fetch()
            self.saveEventually()
        }
    }
    var wishCards: AnyObject? {
        get {
            return self["wishCards"]
        }
        set {
            self["wishCards"] = newValue
            self.wishCodes = [String]()
            for key in self.wishCards as! [String : Int] {
                self.wishCodes.append(key.0)
            }
            self.fetch()
            self.saveEventually()
        }
    }
    
    @NSManaged var tradeCodes: [String]
    @NSManaged var wishCodes: [String]
    @NSManaged var image: PFFile
    
    func tradeCount(card: Card) -> Int {
        if tradeCards == nil {
            return 0
        }
        var dict = tradeCards as! [String: Int]
        let key = card.multiverseid
        
        if dict[key] == nil {
            return 0
        }
        return dict[key]!
    }
    
    func wishCount(card: Card) -> Int {
        if wishCards == nil {
            return 0
        }
        var dict = wishCards as! [String: Int]
        let key = card.multiverseid
        
        if dict[key] == nil {
            return 0
        }
        return dict[key]!
    }
    
    func setValueOfCard(card: Card, inCollectionType type:
        UserCollectionType, value: Int) {
        
            var dict = wishCards as! [String : Int]
            
            if type == .Trade {
                dict = (tradeCards as! [String: Int])
            }
            
            if value == 0 {
                let code = card.multiverseid
                dict.removeValueForKey(code)
                
            }
            else {
                dict[card.multiverseid] = value
            }
            
            
            
            if type == .Trade {
                tradeCards = dict
            }
            else {
                wishCards = dict
            }
    }
    
    var priceOfTradeCollection: Double {
        return priceOfCollection(.Trade)
    }
    
    var priceOfWishCollection: Double {
        return priceOfCollection(.Wish)
    }
    
    private func priceOfCollection(type: UserCollectionType) -> Double {
        var total = 0.0
        var dict = (type == .Trade ? tradeCards : wishCards) as! [String : Int]
        
        for code in dict.keys {
            let card = Card.getCardWithMultiverseid(code)!
            if card.price != nil {
                let price = card.price!.mid * (Double)(dict[code]!)
                if price < 0 {
                    continue
                }
                total += price
            }
        }
        
        return total
    }
    
    func removeCard(card: Card, fromCollection type: UserCollectionType) {
        let cards: AnyObject? = type == .Trade ? tradeCards : wishCards
        
        var dict = cards as! [String: Int]
        if dict[card.multiverseid] > 0 {
            dict[card.multiverseid] = dict[card.multiverseid]! - 1
        }
        if dict[card.multiverseid] == 0 {
            dict.removeValueForKey(card.multiverseid)
        }
        
        if type == .Trade {
            tradeCards = dict
        }
        else {
            wishCards = dict
        }
        
        self.saveEventually()
    }
    
    func addCard(card: Card, inTradeCollection: Bool) {
        if inTradeCollection {
            var dict = tradeCards as! [String: Int]
            if dict[card.multiverseid] != nil {
                dict[card.multiverseid] = dict[card.multiverseid]! + 1
            }
            else {
                dict[card.multiverseid] = 1
            }
            
            tradeCards = dict
        }
        else {
            var dict = wishCards as! [String: Int]
            if dict[card.multiverseid] != nil {
                dict[card.multiverseid] = dict[card.multiverseid]! + 1
            }
            else {
                dict[card.multiverseid] = 1
            }
            
            wishCards = dict
        }
        
        self.saveEventually()
    }
    var tradeCollection: [Card] {
        get {
            var result = [Card]()
            if let cards = tradeCards as? [String: Int] {
                for key in cards.keys {
                    let card = Card.getCardWithMultiverseid(key)
                    if card != nil {
                        result.append(card!)
                    }
                }
            }
            return result
        }
    }
    
    var wishCollection: [Card] {
        get {
            var result = [Card]()
            if let cards = wishCards as? [String: Int] {
                for key in cards.keys {
                    let card = Card.getCardWithMultiverseid(key)
                    if card != nil {
                        result.append(card!)
                    }
                }
            }
            
            return result
        }
    }
    
    override class func currentUser() -> User {
        return User(withoutDataWithObjectId: PFUser.currentUser()?.objectId)
    }
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
}

