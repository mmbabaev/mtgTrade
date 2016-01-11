//
//  UserViewController.swift
//  Mtg Trade
//
//  Created by Михаил on 25.06.15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    var user: User!
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user.image.getData() != nil {
            imageView.image = UIImage(data: user.image.getData()!)
        }
        
        loginLabel.text = user.username
        cityLabel.text = user.city
        
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var cityLabel: UILabel!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bookClicked(sender: AnyObject) {
        performSegueWithIdentifier("showCards", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? UsersCollectionViewController {
            vc.delegate = self
        }
    }
    @IBAction func phoneClicked(sender: AnyObject) {
        
        let phone = user.phone
        let url = NSURL(string: "tel:\(phone)")!
        UIApplication.sharedApplication().openURL(url)
    }

    @IBAction func mailClicked(sender: AnyObject) {
        
        let email = "mmbabaev@gmail.com"
        let url = NSURL(string: "mailto:\(email)")!
        UIApplication.sharedApplication().openURL(url)
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
