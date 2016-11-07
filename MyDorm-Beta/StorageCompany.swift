//
//  StorageCompany.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 11/5/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import Foundation
import UIKit
class StorageCompany {
    private var _name: String!
    private var _image: UIImage!
    // will potentiall replace the stgin in the price index by storable objects just have to make storable objects indexable, whatever that means 
    private var _priceIndex: Dictionary<String,
    Double>!
    private var _pickupTimes: [DateTime]!
    private var _dropoffTimes: [DateTime]!
    
    var name: String {
        return _name
    }
    var priceIndex: Dictionary<String, Double>! {
        return _priceIndex
    }
    var pickupTimes: [DateTime] {
        return _pickupTimes
    }
    var dropoffTimes: [DateTime] {
        return _dropoffTimes
    }
    var image: UIImage {
        return _image
    }
    
    init(name:String, priceIndex: Dictionary<String,
        Double>, pickupTimes: [DateTime], dropoffTimes:[DateTime], image: UIImage) {
        _name = name
        _priceIndex = priceIndex
        _dropoffTimes = dropoffTimes
        _pickupTimes = pickupTimes
        _image = image
    }
    
    func calculateOrderPrice(order: Order) -> Double {
        var total = 0.0
        let items = order.objects
        for item in items {
            if let price = priceIndex[item.name] {
                total += price
            }
        }
        return total
    }

    func getIndividualPrices(order: Order) -> Dictionary<String, Double> {
        var individualPrices = Dictionary<String, Double>()
        let items = order.objects
        for item in items {
            if let price = priceIndex[item.name] {
                individualPrices[item.name] = price
            }
        }
        return individualPrices
    }
}
