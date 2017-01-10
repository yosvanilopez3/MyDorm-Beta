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
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var width: UITextField!
    @IBOutlet weak var length: UITextField!
    var object: StorableObject!
    var order: Order!
    var parent: ObjectListVC!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configureCell(object: StorableObject, order: Order) {
        objectName.text = object.name.capitalized
        height.text = object.height
        width.text = object.width
        length.text = object.length
        self.object = object
        self.order = order
    }
    func configureCell(object: StorableObject) {
        objectName.text = object.name.capitalized
        height.text = object.height
        width.text = object.width
        length.text = object.length
        self.object = object
    }

}
