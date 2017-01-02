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
enum StorageType {
    case InHouse
    case Basement
    case Outdoor
    case OffLocation
}

enum RentType {
    case Summer
    case Monthly
    case Daily
}

 struct Listing {
    var Location: MKPlacemark? // possibly change this to CLLocation
    var storageType = StorageType.InHouse
    var squareFeet: Double?
    var rentType = RentType.Summer
    var rent: Double?
    var dates: [Date]?
    var restrictedItems = [StorableObject]()
    var allowedItems = [StorableObject]()
    var images = [UIImage]()
    var description: String = ""
}
