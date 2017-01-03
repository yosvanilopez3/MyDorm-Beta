//
//  HomeScreenVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 1/3/17.
//  Copyright © 2017 Yosvani Lopez. All rights reserved.
//

import UIKit
import SendBirdSDK

class HomeScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let uid = UserDefaults.standard.value(forKey: KEY_UID) as? String {
            SBDMain.connect(withUserId: uid, completionHandler: { (user, error) in
                
            })
        } else {
            print("In App With No UID Development Error")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
