//
//  Global.swift
//  Mtg Trade
//
//  Created by Михаил on 10.05.15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

var cardsTableView: UITableView = UITableView()
var cardsViewController = UIViewController()



class Global {
    
    
    class func getCardsTableView() -> UITableView {
        return cardsTableView
    }
    
    class func setCardsTableView(tableView: UITableView) {
        cardsTableView = tableView
    }
    
    class func setCardsVC(vc: UIViewController) {
        cardsViewController = vc
    }
    class func getCardsVC() -> UIViewController {
        return cardsViewController
    }
}