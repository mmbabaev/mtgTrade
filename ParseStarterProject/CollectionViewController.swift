//
//  CollectionViewController.swift
//  Mtg Trade
//
//  Created by Михаил on 14.05.15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

enum CardCollectionType {
    case Trade
    case Wish
}

class CollectionViewController: SearchViewController {

    var type: CardCollectionType = .Trade
    var user: User!
    var tradeCards: [Card] = [Card]()
    var wishCards: [Card] = [Card]()
    
    @IBOutlet weak var segmentontrol: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateView() {
        Global.setCardsVC(self)
        
        Global.setCardsTableView(tableView)
        
        self.cards =  type == .Trade ? tradeCards : wishCards
        
        updateTitle()
        tableView.reloadData()
    }
    
    func updateTitle() {
        switch type {
        case .Trade:
            self.title = "   Trade \(user.priceOfTradeCollection) $   "
            
        case .Wish:
            self.title = "   Wish \(user.priceOfWishCollection) $   "
            
        default: break
        }
    }
    override func viewWillAppear(animated: Bool) {
        let op = NSBlockOperation {
            self.user = User.currentUser()
            self.user.fetch()
            print(self.user.username)
            
            self.tradeCards = self.user.tradeCollection
            self.wishCards = self.user.wishCollection
            dispatch_sync(dispatch_get_main_queue()) {
                self.updateView()
            }
        }
        NSOperationQueue().addOperation(op)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CollectionCardCell", forIndexPath: indexPath) as! CollectionCardCell
        
        
        let card = cards[indexPath.row]
        
        
        //  startDownloadOpperation(card)
        
        cell.nameLabel.text = card.name
        cell.setLabel.text = card.set
        
        
        let a = card.prices as! [Double]
        let b = a[0]
        let c = b == -1
        
        
        
        var cardCount = 0
        if type == .Trade {
            cardCount = user.tradeCount(card)
        }
        else {
            cardCount = user.wishCount(card)
        }
       
        
        cell.priceLabel.text = String(card.price!.mid * Double(cardCount))
        
        if card.price!.mid == -1 {
            cell.priceLabel.text = "?"
        }
        
        cell.countLabel.text = String(cardCount)
        
        cell.nameLabel.adjustsFontSizeToFitWidth = true
        cell.setLabel.adjustsFontSizeToFitWidth = true
        cell.priceLabel.adjustsFontSizeToFitWidth = true
        
        return cell

        
    }
    
    @IBAction func segmentIndexChanged(sender: UISegmentedControl) {
        type = sender.selectedSegmentIndex == 0 ? .Trade : .Wish
        updateView()
    }
    
    override func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        MySearch(searchText)
    }
    
    func MySearch(searchText: String) {
        let operation = NSBlockOperation {
            var result = [Card]()
            
            self.cards = self.type == .Trade ? self.user.tradeCollection : self.user.wishCollection
            
            if searchText != "" {
                
                for card in self.cards {
                    if card.name.hasPrefix  (searchText) {
                        result.append(card)
                    }
                }
                
                self.cards = result
            }
            dispatch_sync(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
        
        let queue = NSOperationQueue()
        NSOperationQueue().cancelAllOperations()
        queue.addOperation(operation)
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

























