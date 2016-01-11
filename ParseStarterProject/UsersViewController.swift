//
//  UsersViewController.swift
//  Mtg Trade
//
//  Created by Михаил on 16.05.15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    var card: Card!
    var type: UserCollectionType!
    
    var users = [User]()
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let query = PFQuery(className: "_User")
        let key = type == UserCollectionType.Trade ? "tradeCodes" : "wishCodes"
        
        query.whereKey(key, equalTo: card.multiverseid)
        
        let results = query.findObjects()
        print("Successfully get objects:")
        print(results?.count)
        print(card.multiverseid)
        
        if results != nil {
            for user in results! {
                self.users.append(user as! User)
                print((user as! PFUser).username)
            }
            
           // dispatch_sync(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            //}
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? UserViewController {
            vc.user = users[userIndex]
        }
    }
    var userIndex: Int = 0
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        userIndex = indexPath.row
        performSegueWithIdentifier("showUser", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var user = users[indexPath.row]
        
        let seque = UIStoryboardSegue(identifier: "showCollection", source: self, destination: CollectionViewController())
        
        
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserTableViewCell", forIndexPath: indexPath) as! UserTableViewCell
        let user = users[indexPath.row]
        
        cell.userLabel.text = user.username
        print(user.city)
        cell.cityLabel.text = user.city
        if user.image.getData() != nil {
            cell.userImageView.image = UIImage(data: user.image.getData()!)
        }
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
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
