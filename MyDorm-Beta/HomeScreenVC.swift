//
//  HomeScreenVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 1/3/17.
//  Copyright © 2017 Yosvani Lopez. All rights reserved.
//

import UIKit
import SendBirdSDK

class HomeScreenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var agreementTable: UITableView!
    @IBOutlet weak var listingTable: UITableView!
    @IBOutlet weak var orderTable: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let uid = UserDefaults.standard.value(forKey: KEY_UID) as? String {
            SBDMain.connect(withUserId: uid, completionHandler: { (user, error) in
                
            })
        } else {
                showErrorAlert(title: "Development Error", msg: "In App With No UID ", currentView: self)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
