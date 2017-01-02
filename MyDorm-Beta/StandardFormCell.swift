//
//  StandardFormCell.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 12/9/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class StandardFormCell: UIView {
    let SHADOW_COLOR: CGFloat = 156/255
    override func awakeFromNib() {
        self.layer.borderColor = UIColor(red: SHADOW_COLOR , green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.6).cgColor
        self.layer.borderWidth = 0.5
        self.clipsToBounds = true
    }
}
