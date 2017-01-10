//
//  PreviewListingVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 12/20/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class PreviewListingVC: UIViewController {
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var rentLbl: UILabel!
    @IBOutlet weak var cbFtLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var ownerNameLbl: UILabel!
    @IBOutlet weak var descriptionTxtBox: UITextView!
    var owner: User!
    var listing: Listing!
    var order: Order!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
        addressLbl.text = listing.location
        image.image = listing.image
        rentLbl.text = "$\(listing.rent!)/\(listing.rentType.rawValue)"
        cbFtLbl.text = "\(listing.cubicFeet!) cbft"
        typeLbl.text = listing.storageType.rawValue
        descriptionTxtBox.text = listing.description
        if let date = listing.date {
            dateLbl.text = date
            if let uid = listing.uid {
                DataService.instance.getUserDetails(uid: uid) { (user) in
                        self.ownerNameLbl.text = user.name
                        self.owner = user
                }
            } else {
                showErrorAlert(title: "Development Error", msg: "Listing has no owner", currentView: self)
            }
        } else {
            showErrorAlert(title: "Development Error", msg: "Listing has no availability date", currentView: self)
        }
        // implement own back button
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
    }
    
    func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func submitBtnPressed(sender: UIBarButtonItem) {
        // come up with more secure way to generate a random id
        listing.listingID = "LID\(listing.uid)\(Int(arc4random_uniform(100000000)))"
        DataService.instance.createListing(listing: listing, currentVC: self)
        _ = self.navigationController?.popToRootViewController(animated: true)
        // switch tabs to the home tab
        self.tabBarController?.selectedIndex = 1
    }
   func requestBtnPressed(sender: UIBarButtonItem) {
         performSegue(withIdentifier: "openMessaging", sender: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openMessaging" {
            if let destination = segue.destination as? ChatViewController {
                destination.otherID = owner.uid
                destination.myID = order.uid
                // change this to be the display name 
                destination.senderDisplayName = owner.uid
                // again come up with better way to generate unique number
                destination.UNIQUE_HANDLER_ID = "AID\(owner.uid)\(order.uid)\(Int(arc4random_uniform(100000000)))"
                destination.navigationItem.title = owner.name
                
            }
        }
    }
}
