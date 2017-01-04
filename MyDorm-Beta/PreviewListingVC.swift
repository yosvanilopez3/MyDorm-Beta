//
//  PreviewListingVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 12/20/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class PreviewListingVC: UIViewController {
    var listing: Listing!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

 

    @IBAction func submitListing(_ sender: AnyObject) {
        DataService.instance.createListing(listing: listing)
        self.dismiss(animated: true) { 
        }
    }

}
