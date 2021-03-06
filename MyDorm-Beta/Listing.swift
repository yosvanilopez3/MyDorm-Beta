//
//  Listing.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 12/10/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import Foundation
import UIKit
import MapKit
enum StorageType: String {
    case InHouse = "In House"
    case Basement = "Basement"
    case OffLocation = "Off Location"
}

enum RentType: String {
    case Summer = "Summer"
    case Monthly = "Monthly"
    case Daily = "Daily"
}

 struct Listing {
    var uid: String!
    var listingID: String!
    var location: String!
    var storageType = StorageType.InHouse
    var cubicFeet: String!
    var rentType = RentType.Summer
    var rent: String!
    var date: String!
    var restrictedItems = [StorableObject]()
    var image = UIImage()
    var description: String = ""
}
