//
//  StorableObject.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 10/18/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import Foundation
import UIKit
class StorableObject {
    private var _objectName: String!
    private var _objectType: String!
    var height: String = "12"
    var width: String = "12"
    var length: String = "12"
    var image: UIImage = UIImage(named:"default")!
    var name: String {
        return _objectName
    }
    init (name: String) {
        self._objectName = name
    }
}
