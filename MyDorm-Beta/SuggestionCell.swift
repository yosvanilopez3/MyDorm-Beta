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
    
    @IBAction func objectWasAdded(_ sender: UIButton) {
        if let h = height.text, h != "", let w = width.text, w != "", let l = length.text, l != "" {
            object.width = w
            object.height = h
            object.length = l
            order.objects.append(object)
            DataService.
            parent.order = order
        }
        
    }
    
    func configureCell(object: StorableObject, order: Order, parent: ObjectListVC) {
        objectName.text = object.name
        height.text = object.height
        width.text = object.width
        length.text = object.length
        self.object = object
        self.order = order
        self.parent = parent
    }
    

}
