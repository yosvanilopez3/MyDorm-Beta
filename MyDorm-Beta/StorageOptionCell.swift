//
//  StorageOptionCell.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 11/6/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class StorageOptionCell: UITableViewCell {
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(company: StorageCompany, order: Order) {
      priceLbl.text = "$\(formatPrice(price: company.calculateOrderPrice(order: order)))"
        DataService.instance.getCompanyImage(name: company.name, complete: { (image) in
            self.companyLogo.image = image
        })
        

    }
    
}
