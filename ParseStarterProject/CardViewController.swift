//
//  CardViewController.swift
//  ParseStarterProject
//
//  Created by Михаил on 22.04.15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class CardViewController: UIViewController, UINavigationControllerDelegate {

   
    @IBOutlet weak var image: UIImageView!
    
    weak var delegate: SearchViewController?
    
    @IBOutlet weak var tcgLink: UIImageView!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var mid: UILabel!
    @IBOutlet weak var high: UILabel!
    
    @IBOutlet weak var tradeCountLabel: UILabel!
    @IBOutlet weak var wishCountLabel: UILabel!
    
    @IBOutlet weak var tradeStepper: UIStepper!
    @IBOutlet weak var wishStepper: UIStepper!
    
    
    var card: Card?
    var user = User.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        for button in buttons {
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
          
            button.layer.backgroundColor = UIColor.purpleColor().CGColor
        }
        let width = self.view.bounds.width
        */
        
        tcgLink.gestureRecognizers = [UITapGestureRecognizer(target: self, action: "tcgLink:")]
        
        self.title = delegate?.cardToShow?.name
        card = delegate?.cardToShow
        if (card?.price == nil || card?.needPriceUpdate != nil) {
            UpdatePriceOperation(card: card!, updateView: updateView)
        }
        
        updateView()
        
        let operation = NSBlockOperation {
            self.card?.downloadImage()
            
            dispatch_sync(dispatch_get_main_queue()) {
                self.image.image = self.delegate?.cardToShow?.image
            }
        }
        NSOperationQueue().addOperation(operation)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func updateView() {
        low.text = priceToString(card!.price!.low)
        mid.text = priceToString(card!.price!.mid)
        high.text = priceToString(card!.price!.high)
        let trade = user.tradeCount(card!)
        let wish = user.wishCount(card!)

        tradeCountLabel.text = String(trade)
        wishCountLabel.text = String(wish)
        
        tradeStepper.value = Double(trade)
        wishStepper.value = Double(wish)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
        if (card?.image != nil) {
            self.image.image = card?.image
        }
        
        updateView()
        
        
    }
    
    
    @IBAction func tradeStepperValueChanged(sender: UIStepper) {
        let type = sender.restorationIdentifier == "tradeStepper" ? UserCollectionType.Trade : UserCollectionType.Wish
        
        user.setValueOfCard(card!, inCollectionType: type, value: Int(sender.value))
        
        updateView()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var type: UserCollectionType
        if segue.identifier == "traders" {
            type = .Trade
        }
        else {
            type = .Wish
        }
        print(segue.identifier)
        if let vc = segue.destinationViewController as? UsersViewController {
            vc.type = type
            vc.card = card
        }
    }
    
    func tcgLink(sender: UIImage) {
        
        let url = NSURL(string: card!.magicCardsInfoCode)!
        UIApplication.sharedApplication().openURL(url)
    }
    
}

