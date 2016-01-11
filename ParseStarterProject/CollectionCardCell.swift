//
//  CollectionCard.swift
//  Mtg Trade
//
//  Created by Михаил on 14.05.15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class CollectionCardCell: CardTableViewCell {
    
    @IBOutlet weak var countLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.colors.left = UIColor.redColor()
        self.colors.right = UIColor.greenColor()
    }

    
    
    override func leftDragEnded() {
        let card = Card.getCardWithName(self.nameLabel.text!, fromSet: self.setLabel.text!)
        
        if let viewController = self.vc as? CollectionViewController {
            if viewController.type == .Trade {
                viewController.user.removeCard(card, fromCollection: .Trade)
                viewController.cards = viewController.user.tradeCollection
            }
            else {
                viewController.user.removeCard(card, fromCollection: .Wish)
                viewController.cards = viewController.user.wishCollection
            }
        }
        
        CoreDataHelper.instance.save()
        
        tableView.reloadData()
    }
    
    override func rightDragEnded() {
        let card = Card.getCardWithName(self.nameLabel.text!, fromSet: self.setLabel.text!)
        
        if let viewController = self.vc as? CollectionViewController {
            if viewController.type == .Trade {
                viewController.user.removeCard(card, fromCollection: .Trade)
                
            }
            else {
                viewController.user.removeCard(card, fromCollection: .Wish)
            }
            viewController.updateView()
        }
        
        CoreDataHelper.instance.save()
        
        tableView.reloadData()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.colors.left = UIColor.redColor()
        self.colors.right = UIColor.blueColor()
       
    }
    
    override func getRightLabel() -> String {
        return "Delete"
    }
}
