//
//  SelectedObjectCell.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 11/3/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class SelectedObjectCell: UICollectionViewCell {
    @IBOutlet weak var objectImage: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15.0
        layer.borderColor = UIColor(red: 64, green: 132, blue: 159, alpha: 0.6).cgColor
        layer.borderWidth = 3.0
        clipsToBounds = true
    }
  
    func configureCell(name: String, detail: String) {
        objectImage.image = UIImage(named: "Ok")
    }
    
}
