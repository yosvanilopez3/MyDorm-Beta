//
//  StorableObject.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 10/18/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import Foundation

class StorableObject {
    private var _objectName: String!
    private var _dimensions: Dimensions!
    private var _objectType: String!
    private var _objectSize: String!
    
    var name: String {
        return _objectName
    }
    init (name: String) {
        self._objectName = name
    }
    
    
    
    
}
