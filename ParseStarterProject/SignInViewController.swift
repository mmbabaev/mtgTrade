//
//  RegistrationViewController.swift
//  Mtg Trade
//
//  Created by Михаил on 04.05.15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SignInViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func signInButtonPressed(sender: UIButton) {
        
        if usernameTextField.text == "" || passwordTextField.text == "" {
            showErrorAlert("Enter username and password!")
            return
        }
        
        PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!, block: {
            (user, error: NSError?) in
            if user != nil {
                let alert = UIAlertView(title: "Welcome, \(user!.username!)", message: "", delegate: nil, cancelButtonTitle: "OK")
                
                // to do: init additional data
                
                alert.show()
                user!.save()
            }
            else {
                showErrorAlert(error!.localizedDescription)
            }
            })
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard:")
        
        self.view.addGestureRecognizer(tapRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    func hideKeyboard(recognizer: UIPanGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
}
