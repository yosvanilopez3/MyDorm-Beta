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
let SHADOW_COLOR: CGFloat = 157/255
let BORDER_GREY = UIColor(red: SHADOW_COLOR , green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5)
let DATA_BASE = FIRDatabase.database()
let STORAGE_BASE = FIRStorage.storage()
let URL_BASE = "https://console.firebase.google.com/project/mydorm-beta"
let USER_PASSWORD = "CASAUTHENTICATIONSUCCESS"
let KEY_UID = "uid"
let PRINCETON_ADDRESS = "Princeton, NJ 08544" 

// Main reference to the data base - make reference extensions from here
var SEGUE_LOGIN = "LoggedIn"


func showErrorAlert(title:String, msg: String, currentView: UIViewController) {
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(action)
    currentView.present(alert, animated: true, completion: nil)
}

func formatPrice(price: Double) -> String {
    return String(Int(price))
}

extension String {
       func between(_ left: String, _ right: String) -> String? {
        guard
            let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards)
            , left != right && leftRange.upperBound < rightRange.lowerBound
            else { return nil }
        
        let sub = self.substring(from: leftRange.upperBound)
        let closestToLeftRange = sub.range(of: right)!
        return sub.substring(to: closestToLeftRange.lowerBound)
    }
}
