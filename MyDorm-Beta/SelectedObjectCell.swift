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
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor(red: 212.0/255.0 , green: 212.0/255.0, blue: 213.0/255.0, alpha: 0.3).cgColor
        layer.borderWidth = 1.0
        clipsToBounds = true
    }
  
    func configureCell(object: StorableObject, detail: String, deleteBtnEnabled: Bool = true) {
            deleteBtn.isHidden = !(deleteBtnEnabled)
            self.objectImage.image = object.image
        
    }
    
}
