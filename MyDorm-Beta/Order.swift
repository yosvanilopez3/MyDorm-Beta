//
//  Order.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 10/18/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import Foundation

class Order {
    // set the user through defaults of firebase
    private var _user: User!
    private var _objects: [StorableObject]!
    private var _pickup: DateTime!
    private var _dropoff: DateTime!
    private var _minimumSquareFootage: Float!
    
    var objects: [StorableObject] {
        return _objects
    }
    
    init(objects: [StorableObject], pickup: DateTime, dropoff: DateTime) {
        _objects = objects
        _pickup = pickup
        _dropoff = dropoff
        // these dummy values will be replaced with actual values later
        _minimumSquareFootage = 0.0
        _user = User(uid: "")
    }
    

}
