//
//  Order.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 10/18/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import Foundation

struct Order {
    // force unwrap is fine because the details are only ever accessed after the order is completely built 
    var uid: String!
    var orderID: String!
    var objects = [StorableObject]()
    var pickup: String!
    var dropoff: String!
    
}
