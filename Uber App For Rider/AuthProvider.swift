//
//  AuthProvider.swift
//  Uber App For Rider
//
//  Created by Ranga Madushan on 3/17/18.
//  Copyright © 2018 Ranga Madushan. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias LoginHandler = (_ msg: String?) -> Void

//these are messages to handel error msg
struct LoginErrorCode {
    static let INVALID_EMAIL = "Invalid Email Address, Please Provide A Real Email Address";
    
    static let WRONG_PASSWORRD = "Wrong Password, Please Enter The Correct Password";
    
    static let PROBLEM_CONNECTING = "Here is Problem Connecting To Database";
    
    static let USER_NOT_FOUND = "User Not Found, Please Register";
    
    static let EMAIL_ALREADY_IN_USE = "Email Already In Use, Please Use Another Email";
    
    static let WEAK_PASSWORD = "Password Should Be At least 6 Chracters Long";
    
}


class AuthProvider {
    
    private static let _instance = AuthProvider()
    //this is for create instance of Authprovider to use everywhere
    static var Instance: AuthProvider {
        return _instance;
    }
    
    var userName = "";
    
    func login(withEmail: String, password: String, loginHandler: LoginHandler?){
        
        
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            
            if error != nil{
                
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
            }else{
                
                loginHandler?(nil)
                
            }
            
        })
    } //login func
    
    
    
    func signUp(withEmail: String, password: String, loginHandler: LoginHandler?) {
        
        Auth.auth().createUser(withEmail: withEmail, password: password, completion: { (user, error) in
            
            if error != nil{
                
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
            }else{
                
                if user?.uid != nil {
                    
                    //store the user to database
                    DBProvider.Instance.saveUser(withID: user!.uid, email:withEmail, password: password);
                    
                    
                    //login the user
                    self.login(withEmail: withEmail, password: password, loginHandler: loginHandler);
                    
                }
            }
            
        });
        
        
    } //sign up func
    
    
    func isLoggedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true;
        }
        
        return false;
        
    }//func isLoggedIn
    
    
    func logOut() -> Bool {
        
        if Auth.auth().currentUser != nil {
            
            do {
                
                try Auth.auth().signOut();
                return true;
            }catch{
                
                return false;
            }
        }
        return true;
        
    }// func logout
    
    
    
    func userID() -> String {
        
        return Auth.auth().currentUser!.uid;
        
    }// func userID
    
    
    private func handleErrors(err: NSError, loginHandler: LoginHandler?){
        
        if let errCode = AuthErrorCode(rawValue: err.code){
            
            switch errCode{
                
            case .wrongPassword:
                loginHandler?(LoginErrorCode.WRONG_PASSWORRD);
                break;
                
            case .invalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL);
                break;
                
            case .userNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND);
                
                break;
                
            case .emailAlreadyInUse:
                loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE);
                break;
                
            case .weakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD);
                break;
                
            default:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                
                break;
                
                
            }
        }
        
    }
    
}//class

























