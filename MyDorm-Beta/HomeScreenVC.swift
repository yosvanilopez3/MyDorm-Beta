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

    @IBOutlet weak var orderTable: UITableView!
    var listings = [Listing]()
    var orders = [Order]()
    var agreements = [Agreement]()
    
    enum tableType: Int {
       case Agreement = 0
       case Listing = 1
       case Order = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        agreementTable.tag = tableType.Agreement.rawValue
        listingTable.tag = tableType.Listing.rawValue
        orderTable.tag = tableType.Order.rawValue
        agreementTable.dataSource  = self
        agreementTable.delegate = self
        listingTable.dataSource = self
        listingTable.delegate = self
        orderTable.dataSource = self
        orderTable.delegate = self
        if let uid = UserDefaults.standard.value(forKey: KEY_UID) as? String {
            SBDMain.connect(withUserId: uid, completionHandler: { (user, error) in
            
            })
            DataService.instance.getUserDetails(uid: uid, complete: { (user) in
                DataService.instance.getListings(complete: { (listings) in
                    self.listings = listings.filter{
                        $0.uid == uid
                    }
                })
                self.orders = user.orders
            })
           
          
        } else {
                showErrorAlert(title: "Development Error", msg: "In App With No UID ", currentView: self)
        }
    }
    
 
/*************************************************/
/*          TableView Functions                  */
/*************************************************/

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == tableType.Agreement.rawValue {
            return agreements.count
        }
        else if tableView.tag == tableType.Listing.rawValue {
            return listings.count
        }
        else {
            return orders.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == tableType.Agreement.rawValue {
            
        }
        else if tableView.tag == tableType.Listing.rawValue {
            
        }
        else {
           
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == tableType.Agreement.rawValue {
           
        }
        else if tableView.tag == tableType.Listing.rawValue {
          
        }
        else {
            
        }
      return UITableViewCell()
    }
}
