//
//  MaterialView.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 12/8/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class MaterialView: UIView {
    override func awakeFromNib() {
        self.layer.cornerRadius = 3.0
        self.layer.borderColor = BORDER_GREY.cgColor
        self.layer.borderWidth = 0.3
        self.clipsToBounds = true
    }
    
}
