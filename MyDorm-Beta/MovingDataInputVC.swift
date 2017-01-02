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
    var selectedObjects = [StorableObject]()
    @IBOutlet weak var pickupDateLbl: UIButton!
    @IBOutlet weak var dropoffDateLbl: UIButton!
    @IBOutlet weak var dropoffTimeLbl: UIButton!
    @IBOutlet weak var pickupTimeLbl: UIButton!
    var pickupDate = DateTime(date: Date())
    var dropoffDate =  DateTime(date: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objectListTextField.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        objectListTextField.text = getNameList()
        setPickupLbl()
        setDropoffLbl()
    }
/*************************************************/
/*            Date Set Functions                 */
/*************************************************/
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, didSelect date: Date!) {
        if let calender = controller as? CalenderVC {
            if calender.datetype == DateType.Pickup {
                pickupDate = DateTime(date:date)
                // replace by actual time selection once this is implemented
            }
            else if calender.datetype == DateType.Dropoff {
                dropoffDate = DateTime(date:date)
                // replace by actual time selection once this is implemented
            }
        controller.navigationController?.popViewController(animated: true)
        }
    }
    
    func setPickupLbl() {
        pickupDateLbl.setTitle("\(pickupDate.dateString)", for: UIControlState.normal)
    }
    
    func setDropoffLbl() {
        dropoffDateLbl.setTitle("\(dropoffDate.dateString)", for: UIControlState.normal)
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
                destination.UNWIND_SEGUE = "unwindFromChooseObjects"
            }
        }
        else if segue.identifier == "SetPickupDate" {
            if let destination = segue.destination as? CalenderVC {
                destination.datetype = DateType.Pickup
                destination.delegate = self
            }
        }
        else if segue.identifier == "SetDropoffDate" {
            if let destination = segue.destination as? CalenderVC {
                destination.datetype = DateType.Dropoff
                destination.delegate = self
            }
        }
        else if segue.identifier == "PriceDisplay" {
            if let destination = segue.destination as? PriceDisplayVC {
                destination.currentOrder = createOrder()
            }
        }
        else if segue.identifier == "PickupTimeSegue" {
            // destinationViewController changed to destination
            // this is used to set up a presentation view controller
            if let destination = segue.destination as? SelectTimeVC {
                // change this to load the times available from the company
                destination.availableTimes = [DateTime(date: Date())]
                destination.movingDetailsVC = self
                destination.dateType = DateType.Pickup
            }
        }
        else if segue.identifier == "DropoffTimeSegue" {
            // destinationViewController changed to destination
            // this is used to set up a presentation view controller
            if let destination = segue.destination as? SelectTimeVC {
                // change this to load the times available from the company
                destination.availableTimes = [DateTime(date: Date())]
                destination.movingDetailsVC = self
                destination.dateType = DateType.Dropoff
            }
        }
    }
    
    @IBAction func unwindToMoving(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindFromChooseObjects" {
            if let source = segue.source as? ObjectListVC {
                self.selectedObjects = source.selectedObjects
            }
        }
    }
    
/*************************************************/
/*            Utility Functions                  */
/*************************************************/
  
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
