//
//  StandardTextCell.swift
//  
//
//  Created by Yosvani Lopez on 12/11/16.
//
//

import UIKit

class StandardTextCell: UITableViewCell {
    @IBOutlet weak var cellLbl: UILabel!
    func configureCell(text:String) {
     cellLbl.text = text
    }
}
