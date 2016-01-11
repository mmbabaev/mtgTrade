//
//  Helper.swift
//  Mtg Trade
//
//  Created by Михаил on 04.05.15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit


func showErrorAlert(text: String) {
    let alert = UIAlertView(title: "Error", message: text, delegate: nil, cancelButtonTitle: "OK")
    alert.show()
}

func priceToString(price: Double) -> String {
    if price == -1 {
        return "?"
    }
    return String(price)
}

extension String {
    func toDouble() -> Double {
        return (self as NSString).doubleValue
    }
    
    var length: Int {
        get {
            return self.characters.count
        }
    }
    
    func toLower() -> String {
        return (self as NSString).lowercaseString
    }
    
    func urlString() -> String {
        return (self as NSString).stringByReplacingOccurrencesOfString(" ", withString: "%20")
    }
}



extension NSDate {
    var isDateSame: Bool {
        get {
            let now = NSDate()
            let calender = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            let dif = calender!.compareDate(now, toDate: self, toUnitGranularity: NSCalendarUnit.NSDayCalendarUnit)
        
            if dif == NSComparisonResult.OrderedSame {
                return true
            }
            else {
                return false
            }
        }
    }
}

func getComponentsOfDate(date: NSDate) -> NSDateComponents {
    return NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: date)
}

func dateCode(components: NSDateComponents) -> Double {
   // return Double(components.day * 100 + components.month * 10 + components.year)
    return Double(components.day)
}

func reloadJSON() {
    
    Card.clearCoreData()
    
    let sets = DataManager.getJson().dictionaryValue
    
    var setCount = 0
    
    print(sets.count)
    for set in sets
    {
        setCount += 1
        print(setCount)
        
        for cardDict in set.1["cards"].arrayValue {
            if cardDict["multiverseid"].stringValue == "" {
                continue
            }
            let card = Card()
            card.name = cardDict["name"].stringValue
            
            card.set = set.1["name"].stringValue
            
            //card.isFoil = false
            
            var foreignNames = [String]()
            for foreignName in cardDict["foreignNames"].arrayValue
            {
                foreignNames.append(foreignName["name"].stringValue)
            }
            card.foreignNames = foreignNames
            
            
            var colors = [String]()
            for color in cardDict["colors"].arrayValue {
                colors.append(color.stringValue)
            }
            card.colors = colors
            
            card.code = set.1["code"].stringValue
            card.oldCode = set.1["oldCode"].stringValue
            card.gathererCode = set.1["gathererCode"].stringValue
            
            card.multiverseid = cardDict["multiverseid"].stringValue
            
            card.text = cardDict["number"].stringValue
            
            card.rarity = cardDict["rarity"].stringValue
            
            var prices = [Double]()
            prices.append(-1)
            prices.append(-1)
            prices.append(-1)
            prices.append(-1)
            prices.append(0)
            
            card.prices = prices
            card.magicCardsInfoCode = ""
            
            
            
            CoreDataHelper.instance.save()
        }
    }
}