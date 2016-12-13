//
//  RoundedImage.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 11/29/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit
import Foundation
class RoundedImage: UIImageView {

    override func awakeFromNib() {
        layer.cornerRadius = 3.0
        clipsToBounds = true
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
