//
//  SignUpField.swift
//  IOSMaterial
//
//  Created by Yosvani Lopez on 10/18/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class SignUpField: UITextField {

    override func awakeFromNib() {
        self.layer.cornerRadius = 0.0
        self.layer.borderColor = UIColor(red: 212.0/255.0 , green: 212.0/255.0, blue: 213.0/255.0, alpha: 0.5).cgColor
        self.layer.borderWidth = 0.3
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        self.leftView = paddingView
        self.leftViewMode = UITextFieldViewMode.always
    }
    
}
