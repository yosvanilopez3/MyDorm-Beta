//
//  MovingDataInputVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 10/18/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit
import Foundation
import PDTSimpleCalendar
class MovingDataInputVC: UIViewController, PDTSimpleCalendarViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var objectListTextField: UITextField!
    var calender: Calendar!
    var selectedObjects = [StorableObject]()
    @IBOutlet weak var pickupDateLbl: UIButton!
    @IBOutlet weak var dropoffDateLbl: UIButton!
    @IBOutlet weak var dropoffTimeLbl: UIButton!
    @IBOutlet weak var pickupTimeLbl: UIButton!
    var pickupDate = DateTime()
    var dropoffDate = DateTime()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objectListTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        objectListTextField.text = getNameList()
        setPickupLbl()
        setDropoffLbl()
    }
    
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, didSelect date: Date!) {
        pickupDate = DateTime()
        pickupDate.date = formatDate(date: date)
        // replace by actual time selection once this is implemented
        pickupDate.time = ""
    }
    
    func setPickupLbl() {
        pickupDateLbl.setTitle("Date: \(pickupDate.date)", for: UIControlState.normal)
    }
    
    func setDropoffLbl() {
        dropoffDateLbl.setTitle("Date: \(dropoffDate.date)", for: UIControlState.normal)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        objectListTextField.endEditing(true)
        performSegue(withIdentifier: "ChooseObjects", sender: nil)
    }
    
    func createOrder() -> Order {
        return Order(objects: selectedObjects, pickup: pickupDate, dropoff: dropoffDate)
    }
/*************************************************/
/*                Segue Controls                 */
/*************************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChooseObjects" {
            if let destination = segue.destination as? ObjectListVC {
                destination.selectedObjects = selectedObjects
            }
        }
        if segue.identifier == "SetPickupDate" {
            if let destination = segue.destination as? CalenderVC {
                destination.delegate = self
            }
        }
        if segue.identifier == "SetDropoffDate" {
            if let destination = segue.destination as? CalenderVC {
                destination.delegate = self
            }
        }
        if segue.identifier == "PriceDisplay" {
            if let destination = segue.destination as? PriceDisplayVC {
                destination.currentOrder = createOrder()
            }
        }
    }
/*************************************************/
/*            Utility Functions                  */
/*************************************************/
    func formatDate(date: Date) -> String {
        var formattedDate = date.description
        formattedDate = formattedDate.replacingOccurrences(of: "-", with: "/")
        let month = formattedDate.components(separatedBy: "/")[1]
        let year = formattedDate.components(separatedBy: "/")[0].components(separatedBy: "0")[1]
        let day = formattedDate.components(separatedBy: "/")[2].components(separatedBy: " ")[0]
        formattedDate = "\(month)/\(day)/\(year)"
        print(formattedDate)
        return formattedDate
    }
    func getNameList() -> String {
        var list = ""
        for object in selectedObjects {
            if list.isEmpty {
                list = "\(object.name)"
            }
            else {
                list = "\(list), \(object.name)"
            }
        }
        return list
    }
   }
