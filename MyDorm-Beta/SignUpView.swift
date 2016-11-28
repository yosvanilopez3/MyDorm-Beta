//
//  SignUpView.swift
//  IOSMaterial
//
//  Created by Yosvani Lopez on 10/18/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class SignUpView: UIView {
    let SHADOW_COLOR: CGFloat = 157/255
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 3.0
        self.clipsToBounds = true
    }

}
