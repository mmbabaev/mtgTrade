//
//  SignUpViewController.swift
//  Mtg Trade
//
//  Created by Михаил on 04.05.15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBAction func signUpPressed(sender: UIButton) {
        
        if passwordTextField.text != confirmPasswordTextField.text {
            let alert : UIAlertView = UIAlertView(title: "Error", message: "Passwords are not the same!",       delegate: nil, cancelButtonTitle: "OK")
            
            alert.show()
            return
        }
        if passwordTextField.text == "" || confirmPasswordTextField.text == "" || usernameTextField.text == "" {
            let alert = UIAlertView(title: "Error", message: "One or many fields are empty!", delegate: nil, cancelButtonTitle: "OK")
            
            alert.show()
            return
        }
        
        let user = User()
        
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        user.objectId = user.username! + user.password!
        user.phone = phoneNumberTextField.text!
        user.city = cityTextField.text!
        user.email = emailTextField.text
        
        user["tradeCards"] = [String: Int]()
        user["wishCards"] = [String: Int]()
        
        let file = PFFile(data: UIImagePNGRepresentation(userImageView.image!)!)
        
        user.image = file
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                print(errorString)
                // Show the errorString somewhere and let the user try again.
            }
        }
        print(user.username)
        print(user.password)
        /*
        user.signUpInBackgroundWithBlock({(succeeded: Bool, error: NSError?) -> Void in
            if error != nil {
                println(error!.localizedDescription)
            }
            var message = UIAlertView(title: "Huray!", message: "You successfully sign up!", delegate: nil, cancelButtonTitle: "OK")
            message.show()
        })
        */
        
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signInpressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard:")
        
        self.view.addGestureRecognizer(tapRecognizer)
        
        userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "changeImage:"))
        // Do any additional setup after loading the view.
    }

    @IBAction func changeImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        userImageView.image = image
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func hideKeyboard(recognizer: UIPanGestureRecognizer) {
        self.view.endEditing(true)
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
