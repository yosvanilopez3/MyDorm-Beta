//
//  SelectTimeVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 11/8/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class SelectTimeVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var availableTimes = [DateTime]()
    var movingDetailsVC: MovingDataInputVC!
    var dateType: DateType!
    @IBOutlet weak var timePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.dataSource = self
        timePicker.delegate = self

    }
    @IBAction func cancelBtnPressed(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func doneBtnPressed(_ sender: AnyObject) {
        // fix this it is coded like shit 
        if dateType == DateType.Pickup {
            movingDetailsVC.pickupTimeLbl.setTitle(availableTimes[timePicker.selectedRow(inComponent: 0)].timeString, for: .normal)
        }
        else if dateType == DateType.Dropoff {
            movingDetailsVC.dropoffTimeLbl.setTitle(availableTimes[timePicker.selectedRow(inComponent: 0)].timeString, for: .normal)
        }

       _ = self.navigationController?.popViewController(animated: true)
    }
    
 
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableTimes.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return availableTimes[component].timeString
    }
    
   
}
