//
//  SellerBasicInfoVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 12/10/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit
import PDTSimpleCalendar
class SellerBasicInfoVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, PDTSimpleCalendarViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var datesAvailableView: StandardFormCell!
    @IBOutlet weak var spaceTypeSC1: UISegmentedControl!
    @IBOutlet weak var rentPeriodSC: UISegmentedControl!
    @IBOutlet weak var datesAvailableInput: UITextField!
    @IBOutlet weak var restrictedCollection: UICollectionView!
    var calender = PDTSimpleCalendarViewController()
    var listing: Listing!
    var currentTextField: UITextField!
    override func viewDidLoad() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
        super.viewDidLoad()
        setupSegmentedControls()
        addTapGestures()
        calender.delegate = self
        restrictedCollection.dataSource = self
        restrictedCollection.delegate = self
        // implement own back button
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
    }
    
    func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func addRestrictedItem(_ sender: AnyObject) {
        performSegue(withIdentifier: "selectRestrictedItems", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        restrictedCollection.reloadData()
    }

    func listingIsValid() -> Bool {
        var missingInfoDetails = ""
        if listing.location != nil {
                if listing.cubicFeet != nil {
                    if listing.rent != nil {
                        if listing.date != nil {
                            return true
                        } else {
                            missingInfoDetails = "Select dates available"
                        }
                    } else {
                        missingInfoDetails = "Enter rent amount"
                    }
                } else {
                    missingInfoDetails = "Enter cubic footage"
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    @IBAction func cbftInputChanged(_ sender: UITextField) {
        if let input = sender.text, input != "" {
                listing.cubicFeet = input
            } else {
                // invalidate if there is illegal input
                listing.cubicFeet = nil
            }
    }
    
    @IBAction func rentInputChanged(_ sender: UITextField) {
        if let input = sender.text, input != ""{
            listing.rent = input
                print(input)
        } else {
            listing.rent = nil
            }

    }
    /*************************************************/
    /*            Delegated Inputs                   */
    /*************************************************/
    func addTapGestures() {
        let datesTap = UITapGestureRecognizer(target: self, action:  #selector(handleDateTap(gestureRecognizer:)))
        let viewTap = UITapGestureRecognizer(target: self, action:
        #selector(handleViewTap(gestureRecognizer:)))
        datesTap.delegate = self
        viewTap.delegate = self
        view.isUserInteractionEnabled = true
        datesAvailableView.isUserInteractionEnabled = true
        // add tap as a gestureRecognizer to tapView
        
        self.view.addGestureRecognizer(viewTap)
        datesAvailableView.addGestureRecognizer(viewTap)
        spaceTypeSC1.addGestureRecognizer(viewTap)
        rentPeriodSC.addGestureRecognizer(viewTap)
        restrictedCollection.addGestureRecognizer(viewTap)
        datesAvailableView.addGestureRecognizer(datesTap)
    }
    
    func handleViewTap(gestureRecognizer: UITapGestureRecognizer) {
        if currentTextField != nil {
            currentTextField.endEditing(true)
        }
    }
    
    func handleDateTap(gestureRecognizer: UITapGestureRecognizer) {
        goToCalender()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectRestrictedItems" {
            if let destination = segue.destination as? ObjectListVC {
                destination.listing = listing
                destination.parentVC = self
            }
        }
        if segue.identifier == "addDetails" {
            if let destination = segue.destination as? SellerAdditionalDetailsVC {
                destination.listing = listing
            }
        }

    }

    /*************************************************/
    /*            Calender Inputs                    */
    /*************************************************/
    func goToCalender() {
        calender.weekdayHeaderEnabled = true
        self.navigationController?.pushViewController(calender, animated: true)
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, didSelect date: Date!) {
        listing.date = date.formatDate()
        datesAvailableInput.text = date.formatDate()
        _ = self.navigationController?.popViewController(animated: true)
    }
    /*************************************************/
    /*          CollectionView Functions             */
    /*************************************************/
    
    //build the collection from the center outward
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listing.restrictedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedCell", for: indexPath) as? SelectedObjectCell {
            cell.configureCell(object: listing.restrictedItems[indexPath.row], detail: "details")
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deleteCellFromCollection), for: .touchUpInside)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func deleteCellFromCollection(deleteBtn: UIButton) {
       listing.restrictedItems.remove(at: deleteBtn.tag)
       restrictedCollection.reloadData()
    }

}
