//
//  User.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 10/18/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import Foundation

class User {
    private var firstName: String!
    private var lastName: String!
    private var email: String!
    private var dorm: String!
    private var _uid: String!
    
    
    
    var uid: String {
        return _uid
    }
    
    init(uid: String, userInfo: [String:String]) {
        self._uid = uid
    }
}
    
