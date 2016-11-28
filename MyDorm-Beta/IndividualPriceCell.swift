//
//  IndividualPriceCell.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 11/6/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class IndividualPriceCell: UITableViewCell {
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(itemImage: UIImage, price: Double) {
        self.itemPrice.text = formatPrice(price: price)
        self.itemImage.image = itemImage
    }
}
