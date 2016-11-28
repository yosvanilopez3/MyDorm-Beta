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
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 0.6).cgColor
        layer.borderWidth = 1.0
        clipsToBounds = true
    }
  
    func configureCell(name: String, detail: String) {
        DataService.instance.getObjectImage(name: name, complete: { (image) in
            self.objectImage.image = image
        })
    }
    
}
