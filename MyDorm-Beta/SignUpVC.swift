//  SignUpVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 10/23/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase
class SignUpVC: UIViewController {
// add password and label connections
    @IBOutlet weak var emailAddress: SignUpField!
    @IBOutlet weak var password: SignUpField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRDatabase.database().persistenceEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: KEY_UID) != nil {
            self.performSegue(withIdentifier: SEGUE_LOGIN, sender: nil)
        }
    }
    
    // connect a button to this
    // this requires lots of changes will do this later
    @IBAction func attemptSignUp(sender: RoundedButton) {
        if let emailAddress = emailAddress.text, emailAddress != "" {
            if let password = password.text, password != "" {
                FIRAuth.auth()?.createUser(withEmail: emailAddress, password: password, completion: { (user, error) in
                    if error != nil {
                            print(emailAddress)
                        // expand this to account for all possible error codes
                        showErrorAlert(title: "Could Not Create Account", msg: "Problem creating account", currentView: self)
                        print(error.debugDescription)
                        print(error)
                    } else {
                        let userUID = user!.uid
                        UserDefaults.standard.setValue(userUID, forKey: KEY_UID)
                        // possibly provide a check to see if the account type has a value
                        let userInfo = ["Email Address": emailAddress]
                        DataService.instance.createUser(uid: userUID, user: userInfo)
                        // no need to error check as account exist with this email and password if this point was reached
                        FIRAuth.auth()?.signIn(withEmail: emailAddress, password: password, completion: nil)
                        self.performSegue(withIdentifier: SEGUE_LOGIN, sender: nil)
                    }
                })
            } else {
                showErrorAlert(title: "Invalid Password", msg: "please enter a password", currentView: self)
            }
        } else {
            showErrorAlert(title: "Invalid Email Address", msg: "please enter an email address", currentView: self)
        }
    }
}
