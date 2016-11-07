//
//  SuggestionCell.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 10/18/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class SuggestionCell: UITableViewCell {
    @IBOutlet weak var objectName: UILabel!
    @IBOutlet weak var objectDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
   func configureCell(name: String, detail: String) {
        objectName.text = name
        objectDetail.text = detail
    }
    

}
