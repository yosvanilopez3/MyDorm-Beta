//  SignUpVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 10/23/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase
import SendBirdSDK

class SignUpVC: UIViewController  {
    private let SBAPP_ID = "05E49F01-F143-4357-BC7F-479B05841DD6"
    @IBOutlet weak var logInBtn: RoundedButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRDatabase.database().persistenceEnabled = true
       
    }

    @IBAction func signUpBtnPressed(_ sender: AnyObject) {
        SBDMain.initWithApplicationId(SBAPP_ID)
        if UserDefaults.standard.value(forKey: KEY_UID) != nil {
            performSegue(withIdentifier: "PersistentLogIn", sender: nil)
        }
        else {
            performSegue(withIdentifier: "LogIn", sender: nil)
        }
    }
   
  

    

}
