//
//  SellerBasicInfoVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 12/10/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class SellerBasicInfoVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var spaceTypeSC1: UISegmentedControl!
    @IBOutlet weak var spaceTypeSC2: UISegmentedControl!
    @IBOutlet weak var rentPeriodSC: UISegmentedControl!
    @IBOutlet weak var datesAvailableInput: UITextField!
    @IBOutlet weak var itemRestrictionInput: UITextField!
    @IBOutlet weak var itemsAllowedInput: UITextField!
    var listing: Listing!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControls()
      
    }
    
    /*************************************************/
    /*          Segmented Control Inputs             */
    /*************************************************/
    func setupSegmentedControls() {
        rentPeriodSC.removeBorders()
        spaceTypeSC1.removeBorders()
        spaceTypeSC2.removeBorders()
    }
    @IBAction func selectionChangedForOne(_ sender: AnyObject) {
        // unset the bottom segmentcontrol
        spaceTypeSC2.selectedSegmentIndex = UISegmentedControlNoSegment
        if spaceTypeSC1.selectedSegmentIndex == 0 {
            listing.storageType = StorageType.InHouse
        } else if spaceTypeSC1.selectedSegmentIndex == 1 {
            listing.storageType = StorageType.Basement
        }
    }
    @IBAction func selectionChangedForTwo(_ sender: AnyObject) {
        // unset the top segment control
        spaceTypeSC1.selectedSegmentIndex = UISegmentedControlNoSegment
        if spaceTypeSC2.selectedSegmentIndex == 0 {
            listing.storageType = StorageType.Outdoor
        } else if spaceTypeSC2.selectedSegmentIndex == 1 {
            listing.storageType = StorageType.OffLocation
        }
    }
    /*************************************************/
    /*            Text Field Inputs                  */
    /*************************************************/
    @IBAction func sqftInputChanged(_ sender: UITextField) {
        listing.squareFeet = Double(sender.text!) 
        print(listing.squareFeet)
    }
    @IBAction func rentInputChanged(_ sender: AnyObject) {
    }
 
    
    
    /*************************************************/
    /*            Delegated Inputs                   */
    /*************************************************/
}
