//
//  AccountViewController.swift
//  Mtg Trade
//
//  Created by Михаил on 04.05.15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class AccountViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User.currentUser()
        
        loginLabel.text = user.username
        cityLabel.text = user.city
        
        imageView.image = UIImage(data: user.image.getData()!)
        
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func logOutTapped(sender: UIButton) {
        User.logOutInBackground()
        self.performSegueWithIdentifier("signIn", sender: self)
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
