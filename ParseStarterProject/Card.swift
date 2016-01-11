//
//  Card.swift
//  ParseStarterProject
//
//  Created by Михаил on 14.04.15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Parse

@objc(Card)
class Card: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var colors: AnyObject
    @NSManaged var foil: NSNumber
    @NSManaged var foreignNames: AnyObject
    @NSManaged var number: NSNumber
    @NSManaged var rarity: String
    @NSManaged var set: String
    @NSManaged var code: String
    @NSManaged var oldCode: String
    @NSManaged var gathererCode: String
    @NSManaged var multiverseid: String
    @NSManaged var magicCardsInfoCode: String
    @NSManaged var prices: AnyObject
    @NSManaged var tradeCount: NSNumber
    @NSManaged var wishCount: NSNumber
    @NSManaged var text: String
    
    
    var price: Price? {
        
        get {
                if let prices = self.prices as? [Double] {
                    return Price(low: prices[0], mid: prices[1], high: prices[2], foil: prices[3], tcgLink: self.magicCardsInfoCode)
                }
            return Price(low: 0, mid: 0, high: 0, foil: 0, tcgLink: "")
        }
    }
    
    var image: UIImage? = nil
    
    func updatePrice() {
        NSOperationQueue.mainQueue().cancelAllOperations()
        
        
        var set = self.set
        
        var index = set.startIndex.advancedBy(set.length - 2)
        var indexLast = set.startIndex.advancedBy(set.length - 1)
        
        var preaLastChar = set[index]
        var lastChar = set[indexLast]
        
        
        
        
        /*
        var prices = [Double]()
        prices.append(0)
        prices.append(0)
        prices.append(0)
        prices.append(0)
        prices.append(0)
        self.prices = prices
*/
        // CoreDataHelper.instance.save()
        
        var urlString = "http://partner.tcgplayer.com/x3/phl.asmx/p?pk=BABAEV&s=\(set)&p=\(self.name)"
        urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        if let xmlURL = NSURL(string: urlString) {
            if let data = NSData(contentsOfURL: xmlURL) {
                
                // works only if data is successfully parsed
                // otherwise prints information about error with parsing
                var error: NSError?
                do {
                    let xmlDoc = try AEXMLDocument(xmlData: data)
                    
                    for child in xmlDoc.children {
                        let high = child["product"]["hiprice"].doubleValue
                        let low = child["product"]["lowprice"].doubleValue
                        let mid = child["product"]["avgprice"].doubleValue
                        let foil = child["product"]["foilavgprice"].doubleValue
                        let link = child["product"]["link"].stringValue
                        
                        var Prices = [Double]()
                        Prices.append(low)
                        Prices.append(mid)
                        Prices.append(high)
                        Prices.append(foil)
                        
                        
                        let components = getComponentsOfDate(NSDate())
                        Prices.append(dateCode(components))
                        
                        
                        self.prices = Prices
                        self.magicCardsInfoCode = link
                        
                        return
                    }
                } catch _ {
                }
            }
        }
    
       
    }
    
    func downloadImage() -> Bool {
            if image != nil {
                return false
            }
       
        let mtgPriceurl =  "http://s.mtgprice.com/sets/\(self.set.urlString())/img/\(self.name.urlString()).full.jpg"
        print(mtgPriceurl)
        if let url = NSURL(string: mtgPriceurl) {
            if let data = NSData(contentsOfURL: url){
                self.image = UIImage(data: data)
                return true
            }
            
        }

            let code = (self.code as NSString).lowercaseString
            
            let url1 = "http://magiccards.info/scans/en/\(code)/\(text).jpg"
            print(url1)
            print(self.gathererCode)
            print(self.oldCode)
            //var url1 = "http://magiccards.info/scans/en/\(card.set)/\(card.number).jpg"
            
            
            if let url = NSURL(string: url1) {
                if let data = NSData(contentsOfURL: url){
                    self.image = UIImage(data: data)
                    return true
                }
                
            }
        
        let url2 = "http://magiccards.info/scans/en/\(gathererCode.toLower())/\(text).jpg"
        if let url = NSURL(string: url2) {
            if let data = NSData(contentsOfURL: url){
                self.image = UIImage(data: data)
                return true
            }
        }
        
        return false
    }
    
    var isFoil: Bool {
        get {
            return Bool(foil)
        }
        set {
            foil = NSNumber(bool: newValue)
        }
    }
    
    class var entity: NSEntityDescription {
        return NSEntityDescription.entityForName("Card",
            inManagedObjectContext: CoreDataHelper.instance.context)!
    }
    
    convenience init() {
            self.init(entity: Card.entity,
                insertIntoManagedObjectContext: CoreDataHelper.instance.context)
        
    }
    
    
    
    class func getAllCardsContains(sub: String) -> Array<Card> {
        
        let request = NSFetchRequest(entityName: "Card")
        request.predicate = NSPredicate(format: "name BEGINSWITH %@", sub)
        
        let results = try? CoreDataHelper.instance.context.executeFetchRequest(request)
        
        var cards = results as! [Card]
        
        cards.sortInPlace({ $0.name < $1.name })
        
        return cards
    }
    
    class func getCardWithName(name: String, fromSet set: String) -> Card {
        let request = NSFetchRequest(entityName: "Card")
        request.predicate = NSPredicate(format: "name contains %@ and set contains %@", name, set)
        
        let results = try? CoreDataHelper.instance.context.executeFetchRequest(request)
        
        var cards = results as! [Card]
        
        return cards[0]
    }
    
    class func requestWithPredicate(predicate: NSPredicate) -> [Card] {
        let request = NSFetchRequest(entityName: "Card")
        request.predicate = predicate
    
        let results = try? CoreDataHelper.instance.context.executeFetchRequest(request)
        
        return results as! [Card]
    }
    
    class func clearCoreData() {
        let cards = Card.getAllCards()
        for card: Card in cards {
            CoreDataHelper.instance.context.deleteObject(card)
        }
        
        do {
            try CoreDataHelper.instance.context.save()
        } catch _ {
        }
    }
    
    class func getAllCards() -> [Card] {
        let request = NSFetchRequest(entityName: "Card")
        
        let results = try? CoreDataHelper.instance.context.executeFetchRequest(request)
        
        var cards = results as! [Card]
        
        /*
        for card in cards {
            card.image = nil
        }
        */
        
        cards.sortInPlace({ $0.name < $1.name })
        
        return cards
    }
    
    class func getCardsOfUser(user: PFUser, isTradeCollection: Bool) -> [Card: Int] {
        var cards = [Card : Int]()
        var inProcess = true
        
        var key = "wishCards"
        var pfCards :[PFObject]?
        
        if isTradeCollection {
            pfCards = user["cards"] as? [PFObject]
        }
        else {
            pfCards = user["wishCards"] as? [PFObject]
        }
        for pfCard in pfCards! {
            
            inProcess = true
            let query = PFQuery(className:"PFCard")
            query.whereKey("objectId", equalTo:pfCard.objectId!)
            let objects = query.findObjects()
            if let object = (objects as? [PFObject])?[0] {
                let card = Card.getCardWithMultiverseid(object["multiverseid"] as! String)
                let count = object["count"] as! Int
                
                if (card != nil) {
                    cards[card!] = count
                }
            }
        }
        return cards
    }
    
    class func getCardWithMultiverseid(mult: String) -> Card? {
        let request = NSFetchRequest(entityName: "Card")
        request.predicate = NSPredicate(format: "multiverseid == %@", mult)
        
    
        let results = try? CoreDataHelper.instance.context.executeFetchRequest(request)
        if (results as! [Card]).count == 0 {
            return nil
        }
        
        return (results as! [Card])[0]
    }
    class func getPrice(cards: [Card], ofType type: CardCollectionType) -> Double {
        var price = 0.0
        for card in cards {
            if card.price != nil {
                var p = card.price!.mid
                if type == .Trade {
                    p = p * card.tradeCount.doubleValue
                }
                else {
                    p = p * card.wishCount.doubleValue
                }
                price += p
            }
        }
        
        return price
    }
    
    var needPriceUpdate: Bool {
        let card = self
        if (card.prices as! [Double]).count == 4 {
            var p = card.prices as! [Double]
            p.append(0)
            card.prices = p
            CoreDataHelper.instance.save()
        }
        
        let code = dateCode(getComponentsOfDate(NSDate()))
        if String(code) != (card.rarity) {
            card.rarity = String(code)
            return true
        }
        
        return false
    }
}

struct Price {
    var low, mid, high, foil: Double
    var tcgLink: String
    
    init(low: Double, mid: Double, high: Double, foil: Double, tcgLink: String) {
        self.low = low
        self.mid = mid
        self.high = high
        self.foil = foil
        self.tcgLink = tcgLink
    }
}
