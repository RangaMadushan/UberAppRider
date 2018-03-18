//
//  SignInVC.swift
//  Uber App For Rider
//
//  Created by Ranga Madushan on 3/17/18.
//  Copyright © 2018 Ranga Madushan. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    private let RIDER_SEGUE = "RiderVC"

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logIn(_ sender: AnyObject) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            AuthProvider.Instance.login(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem With Authentication", message: message!)
                } else {
                    
                    self.performSegue(withIdentifier: self.RIDER_SEGUE, sender: nil); //bcz in the closure we have to put self.
                    
                }
                
            })
            
        } else {
            alertTheUser(title: "Email And Password Are Required", message: "Please enter the email and password in the text fields")
        }
        
    }// login func
   
    
    
    
    @IBAction func signUp(_ sender: AnyObject) {
        
        if emailTextField.text! != "" && passwordTextField.text! != "" {
            
            AuthProvider.Instance.signUp(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem With Creating A New User", message: message!)
                } else {
                    
                    self.performSegue(withIdentifier: self.RIDER_SEGUE, sender: nil);
                    
                }
            })
            
        }else{
            alertTheUser(title: "Email And Password Are Required", message: "Please enter the email and password in the text fields")
        }
        
    }// signUp func

    
    
    private func alertTheUser(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    } //func alert user

    
}//class






















