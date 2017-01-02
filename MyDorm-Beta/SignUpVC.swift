//  SignUpVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 10/23/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase
class SignUpVC: UIViewController  {
// add password and label connections
 
    var currentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRDatabase.database().persistenceEnabled = true
        
        if UserDefaults.standard.value(forKey: KEY_UID) != nil {
            performSegue(withIdentifier: "LogIn", sender: nil)
        }
    }

    @IBAction func signUpBtnPressed(_ sender: AnyObject) {
         performSegue(withIdentifier: "LogIn", sender: nil)
    }
   
  

    

}
