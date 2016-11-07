//
//  Dimensions.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 10/18/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import Foundation

class Dimensions {
    private var _height: Float!
    private var _width: Float!
    private var _length: Float!
    
    init (h: Float, w: Float, l: Float) {
        self._height = h
        self._length = l
        self._width = w
    }
}
