//
//  Operations.swift
//  Mtg Trade
//
//  Created by Михаил on 11.06.15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

class LoadImageOperation: NSOperation {
    var user: User
    var update: () -> Void
    
    
    init(user: User, updateView: () -> Void) {
        self.user = user
        update = updateView
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        
        
    }
}

class UpdatePriceOperation: NSOperation {
    var card: Card
    var tableView: UITableView
    var updateViewFunc: (() -> Void)? = nil
    
    init(card: Card, forTableView tableView: UITableView) {
        self.card = card
        self.tableView = tableView
    }
    
    init(card: Card, updateView:() -> Void) {
        self.card = card
        self.tableView = UITableView()
        updateViewFunc = updateView
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        
        card.updatePrice()
        if updateViewFunc == nil {
            dispatch_sync(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
        else {
            updateViewFunc!()
        }
    }
    
    
}