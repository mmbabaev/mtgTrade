//
//  SearchViewController.swift
//  MtgTrade
//
//  Created by Михаил on 13.04.15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var tapRecognizer: UITapGestureRecognizer?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var priceLabel: UILabel!
    
    var searchActive : Bool = false
    var cards = [Card]()
    
    override func viewDidAppear(animated: Bool) {
        
        Global.setCardsVC(self)
        
        Global.setCardsTableView(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search"
        if (Card.getAllCards().count == 0) {
            reloadJSON()
        }
        /*
        var user = User()
        user.username = "Michael"
        user.password = "asd"
        user.email = "mail@mail.ru"
        user.phone = "123"
        user.city = "Moscow"
        user["tradeCards"] = [String : Int]()
        user["wishCards"] = [String : Int]()
        user.tradeCodes = [String]()
        user.wishCodes = [String]()
        user.signUp()
        */
        
        //reloadJSON()
        User.logInWithUsername("Michael", password: "asd")
        tapRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard:")
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        tableView.rowHeight = 62
        
        
        
       
        // Do any additional setup after loading the view.
    }
    
    func hideKeyboard(rec: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    var cardToShow: Card?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CardTableViewCell", forIndexPath: indexPath) as! CardTableViewCell
        
        
        let card = cards[indexPath.row]
        
        cell.nameLabel.text = card.name
        cell.setLabel.text = card.set
        
        
        if card.needPriceUpdate {
            CoreDataHelper.instance.save()
                
            NSOperationQueue().addOperation(UpdatePriceOperation(card: card, forTableView: self.tableView))
        }
        
        
        cell.nameLabel.adjustsFontSizeToFitWidth = true
        cell.setLabel.adjustsFontSizeToFitWidth = true
        cell.priceLabel.adjustsFontSizeToFitWidth = true
        cell.priceLabel.text = String(card.price!.mid)
        
        if card.price!.mid == -1 {
            cell.priceLabel.text = "?"
        }
        
        return cell
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}





extension SearchViewController {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
        
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
       self.view.endEditing(true)
        
        /*
        for card in cards {
            var loadImagesOperation = LoadImagesOperation(card: card, fromCards: cards, forTableView: tableView)
            
            loadImagesOperation.qualityOfService = .Default
            
            var queue = NSOperationQueue()
            
            queue.addOperation(loadImagesOperation)
        }
        */
        
        searchActive = false

    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        var operation = NSBlockOperation(block: {
            
            self.cards = Card.getAllCardsContains(searchBar.text!)
            if(self.cards.count == 0){
                self.searchActive = false;
            } else {
                self.searchActive = true;
            }
            
            dispatch_sync(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
            
        })
        
        var queue = NSOperationQueue()
        NSOperationQueue().cancelAllOperations()
        queue.addOperation(operation)
    }
}



extension SearchViewController {
    
    
    func addCard(card: Card, usingAlertTitle title: String, withText text: String, inTradeCollection: Bool) {
        
        
        
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: title, message: text, preferredStyle: UIAlertControllerStyle.Alert)
            
            for var i = 1; i < 5; i++ {
                let action = UIAlertAction(title: String(i), style: UIAlertActionStyle.Default, handler: {
                    (alertAction: UIAlertAction!) in
                    self.buttonInAlertViewClicked(card, withCount: Int(alertAction.title!)!, inTradeCollection: inTradeCollection)
                })
                alert.addAction(action)
                
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            
            
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func buttonInAlertViewClicked(card: Card, let withCount count: Int, inTradeCollection: Bool) {
        
        
        let user = User.currentUser()
        for var i = 0; i < count; i++ {
            user.addCard(card, inTradeCollection: inTradeCollection)
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        cardToShow = cards[indexPath.row]
        
        performSegueWithIdentifier("showCard", sender: self)
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCard" {
            if let cardVC = segue.destinationViewController as? CardViewController {
                cardVC.card = cardToShow
                cardVC.delegate = self
                
            }
        }
    }
}

