//
//  DataService.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 10/23/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import Foundation
import Firebase
class DataService {
    static let instance = DataService()
    private let _USER_BASE = DATA_BASE.reference(withPath: "users")
    private let _ORDER_BASE = DATA_BASE.reference(withPath: "order")
    private let _ITEM_BASE = DATA_BASE.reference(withPath: "storableobjects")
    private let _COMPANY_BASE = DATA_BASE.reference(withPath: "Companies")
    var storableObjects = [StorableObject]()
    var storageCompanies = [StorageCompany]()
    
    var USER_BASE: FIRDatabaseReference {
        return _USER_BASE
    }
    
/*************************************************/
/*      FireBase Data Download Functions         */
/*************************************************/
    func getStorableObjects(complete: @escaping complete) {
        // read in storable objects
        _ITEM_BASE.observe(.value, with: { (snapshot) in
            var loadedobjects = [StorableObject]()
            if let objects = snapshot.value as? Dictionary<String, String> {
                for object in objects.values {
                    loadedobjects.append(StorableObject(name: object))
                }
            }
            self.storableObjects = loadedobjects
            complete()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getCompanydata(complete: @escaping complete) {
        _COMPANY_BASE.observe(.value, with: { (snapshot) in
            var loadededcompanies = [StorageCompany]()
            print(snapshot.value)
            if let companies = snapshot.value as? Dictionary<String, Dictionary<String, AnyObject>> {
                for company in companies.values {
                    // later on add the pickup and drop off date lists here
                    if let companyname = company["name"] as? String, let index = company["Price Index"] as? Dictionary<String, Dictionary<String, AnyObject>> {
                        var priceIndex = Dictionary<String, Double>()
                        for item in index.values {
                            if let name = item["name"] as? String {
                                for option in item.values {
                                    if let currentOpt = option as? Dictionary<String,
                                        AnyObject> {
                                        if let price = currentOpt["price"] as? Double {
                                            // need to add something to distinguish prices of different options for each type of item
                                            priceIndex["\(name)"] = price
                                        }
                                    }
                                }
                            }
                        }
                        // need to replace dummy pickup and dropoff times with actual ones as well as the UI Image
                        loadededcompanies.append(StorageCompany(name: companyname, priceIndex: priceIndex, pickupTimes: [DateTime](), dropoffTimes: [DateTime](), image: UIImage()))
                    }
                }
            }
            self.storageCompanies = loadededcompanies
            complete()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
/*************************************************/
/*       FireBase Data Upload Functions          */
/*************************************************/

    func createUser(uid: String, user: Dictionary<String, String>) {
        USER_BASE.child(uid).setValue(user)
    }
    
    func createOrder(uid: String, user: Dictionary<String, String>) {
        USER_BASE.child(uid).setValue(user)
    }
    
}
