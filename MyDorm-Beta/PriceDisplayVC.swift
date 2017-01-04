//
//  PriceDisplayVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 11/2/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit
// in the future there would be a price index for each company and each then a calculation would be done for each 
class PriceDisplayVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var storageOptionsTbl: UITableView!
    var currentOrder: Order!
    var storageCompanies = [StorageCompany]()
    var listings = [Listing]()
    override func viewDidLoad() {
        super.viewDidLoad()
        storageOptionsTbl.delegate = self
        storageOptionsTbl.dataSource = self
        // will probably move data retreival to beginning of moving launch to have all data loaded by time of use, will also add a local version of the data that would be updated only if the user is connected to the internet
        DataService.instance.getCompanydata { 
            self.storageCompanies = DataService.instance.storageCompanies
            self.storageOptionsTbl.reloadData()
        }
        DataService.instance.getListings { 
            self.listings = DataService.instance.listings
            self.storageOptionsTbl.reloadData()
        }
    }
    @IBAction func backBtnPressed(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
/*************************************************/
/*               Segue Functions                 */
/*************************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeDetailsSegue" {
            if let destination = segue.destination as? IndividualPriceDisplayVC {
                if let button = sender as? UIButton {
                    destination.priceIndex = storageCompanies[button.tag].getIndividualPrices(order: currentOrder)
                }
            }
        }
    }
    
/*************************************************/
/*            TableView Functions                */
/*************************************************/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (storageCompanies.count + listings.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StorageOptionCell", for: indexPath) as? StorageOptionCell {
            if indexPath.row < storageCompanies.count {
                cell.configureCell(company: storageCompanies[indexPath.row], order: currentOrder)
            } else {
                cell.configureCell(listing: listings[indexPath.row - storageCompanies.count], order: currentOrder)
            }
              return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
/*************************************************/
/*            Utility Functions                  */
/*************************************************/


}
