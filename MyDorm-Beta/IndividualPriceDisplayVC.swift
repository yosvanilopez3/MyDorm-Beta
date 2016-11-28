//
//  IndividualPriceDisplayVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 11/8/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class IndividualPriceDisplayVC: UITableViewController {
    // change so that we have an image mapped to a price that can be indexed
    var priceIndex: Dictionary<String, Double>!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func doneBtnPressed(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
  
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceIndex.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "IndividualPriceCell", for: indexPath) as? IndividualPriceCell {
            cell.configureCell(itemImage: UIImage(named: "default")!, price: 0.0)
            return cell
        }

        return UITableViewCell()
    }




}
