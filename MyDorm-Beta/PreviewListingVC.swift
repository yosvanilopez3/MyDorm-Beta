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
    @IBOutlet weak var sqFtLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var ownerNameLbl: UILabel!
    @IBOutlet weak var descriptionTxtBox: UITextView!
    var owner: User!
    var listing: Listing!
    var order: Order!
    override func viewDidLoad() {
        super.viewDidLoad()
        addressLbl.text = listing.location
        image.image = listing.image
        rentLbl.text = "\(listing.rent) / \(listing.rentType.rawValue)"
        sqFtLbl.text = listing.squareFeet
        dateLbl.text = listing.date?.formatDate()
        typeLbl.text = listing.storageType.rawValue
        descriptionTxtBox.text = listing.description
        DataService.instance.getUserDetails(uid: listing.uid!) { (user) in
                self.ownerNameLbl.text = user.name
                self.owner = user
        }

    }
    
    @IBAction func submitListing(_ sender: AnyObject) {
        if order == nil {
            DataService.instance.createListing(listing: listing)
            _ = self.navigationController?.popToRootViewController(animated: true)
            // switch tabs to the home tab 
        }
    }
    @IBAction func requestListing(_ sender: AnyObject) {
        performSegue(withIdentifier: "openMessaging", sender: nil)
    }

    @IBAction func backBtn(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
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
                
            }
        }
    }
}
