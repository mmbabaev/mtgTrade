//
//  UsersCollectionViewController.swift
//  Mtg Trade
//
//  Created by Михаил on 26.06.15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class UsersCollectionViewController: CollectionViewController {

    var delegate: UserViewController!
    
    override func viewWillAppear(animated: Bool) {
        let op = NSBlockOperation {
            self.user = self.delegate.user
            print(self.user.username)
            
            /*
            User.logInWithUsername("Michael", password: "asd")
            
            
            self.user.fetch()
            */
            self.tradeCards = self.user.tradeCollection
            self.wishCards = self.user.wishCollection
            dispatch_sync(dispatch_get_main_queue()) {
                self.updateView()
            }
        }
        NSOperationQueue().addOperation(op)

    }
    override func MySearch(searchText: String) {
        let op = NSBlockOperation {
            self.user = self.delegate.user
            self.user.fetch()
            
            self.tradeCards = self.delegate.user.tradeCollection
            self.wishCards = self.delegate.user.wishCollection
            dispatch_sync(dispatch_get_main_queue()) {
                self.updateView()
            }
        }
        NSOperationQueue().addOperation(op)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
