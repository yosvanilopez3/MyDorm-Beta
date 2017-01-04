//
//  DataService.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 10/23/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import Foundation
import Firebase
import UIKit
class DataService {
    static let instance = DataService()
    private let _USER_BASE = DATA_BASE.reference(withPath: "Users")
    private let ORDER_BASE = DATA_BASE.reference(withPath: "Orders")
    private let LISTING_BASE = DATA_BASE.reference(withPath: "Listings")
    private let ITEM_BASE = DATA_BASE.reference(withPath: "Storable Objects")
    private let COMPANY_BASE = DATA_BASE.reference(withPath: "Companies")
    private let storage = STORAGE_BASE
    private var _storableObjects = [StorableObject]()
    private var _storageCompanies = [StorageCompany]()
    private var _listings = [Listing]()
    private var downloadedObjectImages = Dictionary <String, UIImage>()
    private var downloadedCompanyImages = Dictionary <String, UIImage>()
    
    var storableObjects : [StorableObject] {
        return _storableObjects
    }
    var storageCompanies : [StorageCompany] {
        return _storageCompanies
    }
    var listings : [Listing] {
        return _listings
    }
    var USER_BASE: FIRDatabaseReference {
        return _USER_BASE
    }
    
/*************************************************/
/*      FireBase Data Download Functions         */
/*************************************************/
    func getStorableObjects(complete: @escaping complete) {
        // read in storable objects
        ITEM_BASE.observe(.value, with: { (snapshot) in
            var loadedobjects = [StorableObject]()
            if let objects = snapshot.value as? Dictionary<String, String> {
                for object in objects.values {
                    loadedobjects.append(StorableObject(name: object))
                }
            }
            self._storableObjects = loadedobjects
            complete()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getCompanydata(complete: @escaping complete) {
        COMPANY_BASE.observe(.value, with: { (snapshot) in
            var loadededcompanies = [StorageCompany]()
            print(snapshot.value)
            if let companies = snapshot.value as? Dictionary<String, Dictionary<String, AnyObject>> {
                for company in companies.values {
                    // later on add the pickup and drop off date lists here
                    if let companyname = company["Name"] as? String, let index = company["Price Index"] as? Dictionary<String, Dictionary<String, AnyObject>> {
                        var priceIndex = Dictionary<String, Double>()
                        for item in index.values {
                            if let name = item["Name"] as? String {
                                for option in item.values {
                                    if let currentOpt = option as? Dictionary<String,
                                        AnyObject> {
                                        if let price = currentOpt["Price"] as? Double {
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
            self._storageCompanies = loadededcompanies
            complete()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // attempts to download image that is inquired if image could not be downloaded returns stock image
    func getObjectImage (name: String, complete: @escaping (UIImage)->()) {
        if let img = downloadedObjectImages[name] {
            complete(img)
        } else {
            let reference: FIRStorageReference = storage.reference(withPath: "\(name.lowercased().replacingOccurrences(of: " ", with: "")).jpg")
            reference.data(withMaxSize: (80 * 1024 * 1024), completion: { (data, error) in
                if (error != nil) {
                    print(error.debugDescription)
                } else {
                    if let img = UIImage(data: data!) {
                        self.downloadedObjectImages[name] = img
                        complete(img)
                    }
                }
                complete(UIImage(named: "default")!)
            })
        }
    }
    // attempts to download image that is inquired if image could not be downloaded returns stock image
    func getCompanyImage (name: String, complete: @escaping (UIImage)->()) {
        if let img = downloadedCompanyImages[name] {
            complete(img)
        } else {
            let reference: FIRStorageReference = storage.reference(withPath: "\(name.lowercased().replacingOccurrences(of: " ", with: "")).jpg")
            reference.data(withMaxSize: (80 * 1024 * 1024), completion: { (data, error) in
                if (error != nil) {
                    print(error.debugDescription)
                } else {
                    if let img = UIImage(data: data!) {
                        self.downloadedCompanyImages[name] = img
                        complete(img)
                    }
                }
                complete(UIImage(named: "default")!)
            })
        }
    }
    func getUserDetails (uid: String, complete: @escaping (User)->()) {
        var userInfo = [String:Any]()
        USER_BASE.child(uid).observe(.value, with: { (snapshot) in
            if let details = snapshot.value as? Dictionary<String, Any> {
                 userInfo = details
                }
            complete(User(uid: uid, userInfo: userInfo))
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    func getListings(complete: @escaping complete) {
        LISTING_BASE.observe(.value, with: { (snapshot) in
            var listings = [Listing]()
            if let lists = snapshot.value as? Dictionary<String, (Dictionary<String, String>) > {
                for listing in lists.values {
                    var newListing = Listing()
                    newListing.uid = listing["uid"]
                    newListing.location = listing["Location"]
                    newListing.storageType = StorageType(rawValue: listing["Storage Type"]!)!
                    newListing.rentType = RentType(rawValue: listing["Rent Type"]!)!
                    newListing.rent = listing["Rent"]
                    newListing.squareFeet = listing["Square Feet"]
                    listings.append(newListing)
                }
            }
            self._listings = listings
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
    func createListing(listing: Listing) {
        USER_BASE.child(listing.uid!).child("Listings").child(listing.listingID!).child("rented").setValue("false")
        // change these to have better string representation of details
        // make all of this safe if there is time revamp code base with proper code checking
        let listinginfo = ["uid": listing.uid!, "Location": listing.location!, "Storage Type":listing.storageType.rawValue, "Rent Type" : listing.rentType.rawValue, "Rent" : listing.rent!, "Square Feet" :  listing.squareFeet!]
        LISTING_BASE.child(listing.listingID!).setValue(listinginfo)
        
    }
}
