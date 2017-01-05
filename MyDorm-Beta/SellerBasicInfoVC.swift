//
//  SellerBasicInfoVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 12/10/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit
import PDTSimpleCalendar
class SellerBasicInfoVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, PDTSimpleCalendarViewDelegate {
    
    @IBOutlet weak var datesAvailableView: StandardFormCell!
    @IBOutlet weak var allowedItemsView: StandardFormCell!
    @IBOutlet weak var restrictedItemsView: StandardFormCell!
    @IBOutlet weak var spaceTypeSC1: UISegmentedControl!
    @IBOutlet weak var rentPeriodSC: UISegmentedControl!
    @IBOutlet weak var datesAvailableInput: UITextField!
    @IBOutlet weak var itemRestrictionInput: UITextField!
    @IBOutlet weak var itemsAllowedInput: UITextField!
    var calender = PDTSimpleCalendarViewController()
    var listing: Listing!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControls()
        addTapGestures()
        calender.delegate = self
    }
    
    func listingIsValid() -> Bool {
        var missingInfoDetails = ""
        if listing.location != nil {
                if listing.squareFeet != nil {
                    if listing.rent != nil {
                        if listing.dates != nil {
                            return true
                        } else {
                            missingInfoDetails = "Select dates available"
                        }
                    } else {
                        missingInfoDetails = "Enter rent amount"
                    }
                } else {
                    missingInfoDetails = "Enter square footage"
                }
        } else {
            showErrorAlert(title: "Developemt Error", msg: "missing location when location should have been selected", currentView: self)
            return false
        }
        showErrorAlert(title: "Missing Information", msg: missingInfoDetails, currentView: self)
        return false 
    }
    
    @IBAction func nextBtnPressed(_ sender: AnyObject) {
        if listingIsValid() {
            performSegue(withIdentifier: "addDetails", sender: nil) 
        }
    }
   
    /*************************************************/
    /*          Segmented Control Inputs             */
    /*************************************************/
    func setupSegmentedControls() {
        rentPeriodSC.removeBorders()
        spaceTypeSC1.removeBorders()
    }
    
    @IBAction func rentTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            listing.rentType = RentType.Summer
        } else if sender.selectedSegmentIndex == 1 {
            listing.rentType = RentType.Monthly
        } else if sender.selectedSegmentIndex == 2 {
            listing.rentType = RentType.Daily
        }
    }


    @IBAction func selectionChangedForOne(_ sender: AnyObject) {
        if sender.selectedSegmentIndex == 0 {
            listing.storageType = StorageType.InHouse
        } else if sender.selectedSegmentIndex == 1 {
            listing.storageType = StorageType.Basement
        } else if sender.selectedSegmentIndex == 2 {
            listing.storageType = StorageType.OffLocation

        }
    }
   
    /*************************************************/
    /*            Text Field Inputs                  */
    /*************************************************/
    @IBAction func sqftInputChanged(_ sender: UITextField) {
        if let input = sender.text, input != "" {
                listing.squareFeet = input
            } else {
                // invalidate if there is illegal input
                listing.squareFeet = nil
            }
    }
    
    @IBAction func rentInputChanged(_ sender: UITextField) {
        if let input = sender.text, input != ""{
                listing.rent = input
        } else {
                // invalidate if there is illegal input
                listing.rent = nil
            }

    }
    /*************************************************/
    /*            Delegated Inputs                   */
    /*************************************************/
    func addTapGestures() {
        let datesTap = UITapGestureRecognizer(target: self, action:  #selector(handleDateTap(gestureReconizer:)))
        let allowedTap = UITapGestureRecognizer(target: self, action:  #selector(handleAllowedTap(gestureReconizer:)))
        let restrictedTap = UITapGestureRecognizer(target: self, action: #selector(handleRestrictedTap(gestureReconizer:)))
        datesTap.delegate = self
        allowedTap.delegate = self
        restrictedTap.delegate = self
        datesAvailableView.isUserInteractionEnabled = true
        allowedItemsView.isUserInteractionEnabled = true
        restrictedItemsView.isUserInteractionEnabled = true
        // add tap as a gestureRecognizer to tapView
        datesAvailableView.addGestureRecognizer(datesTap)
        allowedItemsView.addGestureRecognizer(allowedTap)
        restrictedItemsView.addGestureRecognizer(restrictedTap)
    }
    
    func handleDateTap(gestureReconizer: UITapGestureRecognizer) {
        goToCalender()
    }
    
    func handleAllowedTap(gestureReconizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "selectAllowedItems", sender: nil)
    }
    func handleRestrictedTap(gestureReconizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "selectRestrictedItems", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectRestrictedItems" {
            if let destination = segue.destination as? ObjectListVC {
                destination.listing = listing
                destination.UNWIND_SEGUE = "unwindFromSelectRestrictedItems"
            }
        }
        if segue.identifier == "selectAllowedItems" {
            if let destination = segue.destination as? ObjectListVC {
                destination.listing = listing
                destination.UNWIND_SEGUE = "unwindFromSelectAllowedItems"
            }
        }
        if segue.identifier == "addDetails" {
            if let destination = segue.destination as? SellerAdditionalDetailsVC {
                destination.listing = listing
            }
        }

    }
    @IBAction func unwindFromSelectRestrictedItems(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindFromSelectRestrictedItems" {
            if let source = segue.source as? ObjectListVC {
                listing = source.listing
            }
        }
    }
    @IBAction func unwindFromSelectAllowedItems(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindFromSelectAllowedItems" {
            if let source = segue.source as? ObjectListVC {
                listing = source.listing
            }
        }
    }
    /*************************************************/
    /*            Calender Inputs                    */
    /*************************************************/
    func goToCalender() {
        present(calender, animated: true, completion: nil)
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, didSelect date: Date!) {
        var dates = [Date]()
        dates.append(date)
        listing.dates = dates
        datesAvailableInput.text = date.formatDate()
        self.dismiss(animated: true, completion: nil)
    }
    
}
