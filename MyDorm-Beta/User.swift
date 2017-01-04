//
//  User.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 10/18/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import Foundation

class User {
    private var _firstName: String!
    private var _lastName: String!
    private var _email: String!
    private var _dorm: String!
    private var _uid: String!
    
    
    
    var uid: String {
        return _uid
    }
    var firstName: String {
        return _firstName
    }
    var lastName: String {
        return _lastName
    }
    var email: String {
        return _email
    }
    var dorm: String {
        return _dorm
    }
    
    init(uid: String, userInfo: [String:Any]) {
        if let first = userInfo["First Name"] as? String {
            _firstName = first
        }
        if let last = userInfo["Last Name"] as? String {
            _lastName = last
        }
        if let mail = userInfo["Email"] as? String {
            _email = mail
        }
        if let room = userInfo["Dorm"] as? String {
            _dorm = room
        }
        self._uid = uid
    }
}
    
