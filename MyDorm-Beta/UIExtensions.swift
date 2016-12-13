//
//  UIExtensions.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 12/10/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import Foundation
import UIKit

/* Segmented Control Extension */
extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: UIColor.white), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: BORDER_GREY), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}

extension UITextView {
    func addPlaceholder(_ placeholderText: String) {
        let placeholder = UILabel()
        placeholder.tag = 0x1abe1
        placeholder.text = placeholderText
        placeholder.numberOfLines = 0
        placeholder.font = UIFont.italicSystemFont(ofSize: (self.font?.pointSize)!)
        placeholder.sizeToFit()
        placeholder.frame.origin = CGPoint(x: 5, y: (self.font?.pointSize)! / 2)
        placeholder.textColor = UIColor(white: 0, alpha: 0.3)
        self.addSubview(placeholder)
        updatePlaceholderVisibility()
    }
    
    func updatePlaceholderVisibility() {
        if let placeholder = self.viewWithTag(0x1abe1)  {
            placeholder.isHidden = !self.text.isEmpty
        }
    }
}
