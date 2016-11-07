//
//  CalenderVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 10/18/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit
import PDTSimpleCalendar
class CalenderVC: PDTSimpleCalendarViewController, UINavigationControllerDelegate {
    //create and enum that the calling VC can set as either pick up or drop off 
    //make only the available dates selectable
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
    }
}
