//
//  CardTableViewCell.swift
//  ParseStarterProject
//
//  Created by Михаил on 14.04.15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

protocol CardTableViewCellDelegate {
    func addCardToCollectionWithName(cardName: String)
}

class CardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var leftLabel: UILabel!, rightLabel: UILabel!
    let kUICuesMargin: CGFloat = 10.0, kUICuesWidth: CGFloat = 80.0

    
    var colors = (left: UIColor(red: 1, green: 0.68, blue: 0.0, alpha: 1.0), right: UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0))
    var leftBackgroundColor: UIColor  {
        return UIColor.greenColor()
    }
    var vc = Global.getCardsVC()
    var tableView = Global.getCardsTableView()
    
    func leftDragRelease() {
        tableView.backgroundColor = colors.left
    }
    
    func rightDragRelease() {
        tableView.backgroundColor = colors.right
    }
    
    func leftDragEnded() {
        let card = Card.getCardWithName(self.nameLabel.text!, fromSet: self.setLabel.text!)
        
        if let searchVC = vc as? SearchViewController {
            searchVC.addCard(card, usingAlertTitle: "How many cards to add to trade list?", withText: "", inTradeCollection: true)
        }
    }
    
    func rightDragEnded() {
        let card = Card.getCardWithName(self.nameLabel.text!, fromSet: self.setLabel.text!)
        
        if let searchVC = vc as? SearchViewController {
            searchVC.addCard(card, usingAlertTitle: "How many cards to add to wish list?", withText: "", inTradeCollection: false)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        leftLabel = createCueLabel()
        leftLabel.text = "Wish list☞"
        leftLabel.textAlignment = .Right
        addSubview(leftLabel)
        rightLabel = createCueLabel()
        rightLabel.text = "☜Trade list"
        rightLabel.textAlignment = .Left
        addSubview(rightLabel)
        let recognizer = UIPanGestureRecognizer(target: self, action: "handleCellSwipe:")
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    
    func getRightLabel() -> String {
        return "Trade List"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        leftLabel = createCueLabel()
        leftLabel.text = "Wish list"
        leftLabel.textAlignment = .Right
        addSubview(leftLabel)
        rightLabel = createCueLabel()
        rightLabel.text = getRightLabel()
        rightLabel.textAlignment = .Left
        addSubview(rightLabel)
        let recognizer = UIPanGestureRecognizer(target: self, action: "handleCellSwipe:")
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    var originalCenter = CGPoint()
    var addInCollectionOnDragRelease = false
    var addInWishListOnDragRelease = false
    
    func handleCellSwipe(recognizer: UIPanGestureRecognizer) {
        // 1
        if recognizer.state == .Began {
            // when the gesture begins, record the current center location
            originalCenter = center
        }
        // 2
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            // has the user dragged the item far enough to initiate a delete/complete?
            addInCollectionOnDragRelease = frame.origin.x < -frame.size.width / 3
            addInWishListOnDragRelease = frame.origin.x > frame.size.width / 3
            
            if addInWishListOnDragRelease || addInCollectionOnDragRelease {
                
            }
            else {
                tableView.backgroundColor = UIColor.grayColor()
            }
            
            if addInWishListOnDragRelease {
                self.rightDragRelease()
            }
            
            if addInCollectionOnDragRelease {
                self.leftDragRelease()
            }
            
            // fade the contextual clues
            let cueAlpha = fabs(frame.origin.x) / (frame.size.width / 3.0)
            leftLabel.alpha = cueAlpha
            rightLabel.alpha = cueAlpha
            // indicate when the user has pulled the item far enough to invoke the given action
            leftLabel.textColor = UIColor.whiteColor()
            rightLabel.textColor = UIColor.whiteColor()
        }
        // 3
        if recognizer.state == .Ended {
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                width: bounds.size.width, height: bounds.size.height)
            
            
            
            if addInCollectionOnDragRelease {
                self.leftDragEnded()
            }
                
            else {
                if addInWishListOnDragRelease {
                    self.rightDragEnded()
                }
            }
            tableView.backgroundColor = UIColor.whiteColor()
            UIView.animateWithDuration(0.3, animations: {self.frame = originalFrame})
            
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        leftLabel.frame = CGRect(x: -kUICuesWidth - kUICuesMargin, y: 0,
            width: kUICuesWidth, height: bounds.size.height)
        rightLabel.frame = CGRect(x: bounds.size.width + kUICuesMargin, y: 0,
            width: kUICuesWidth, height: bounds.size.height)
    }
    
    func createCueLabel() -> UILabel {
        let label = UILabel(frame: CGRect.null)
        label.textColor = UIColor.blackColor()
        label.font = UIFont.boldSystemFontOfSize(16.0)
        label.backgroundColor = UIColor.clearColor()
        return label
    }
}























