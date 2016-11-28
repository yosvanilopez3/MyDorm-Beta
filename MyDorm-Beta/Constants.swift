//
//  Constants.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 10/23/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import UIKit

typealias complete = () -> ()
let DATA_BASE = FIRDatabase.database()
let STORAGE_BASE = FIRStorage.storage()
let URL_BASE = "https://console.firebase.google.com/project/mydorm-beta"
let KEY_UID = "uid"
// Main reference to the data base - make reference extensions from here
var SEGUE_LOGIN = "LogIn"

func showErrorAlert(title:String, msg: String, currentView: UIViewController) {
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(action)
    currentView.present(alert, animated: true, completion: nil)
}

func formatPrice(price: Double) -> String {
    return String(format: "%.2f", price)
}
