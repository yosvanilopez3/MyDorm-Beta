//
//  PriceDisplayVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 11/2/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit
// in the future there would be a price index for each company and each then a calculation would be done for each 
class PriceDisplayVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var storageOptionsTbl: UITableView!
    var order: Order!
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
        DataService.instance.getListings {listings in
            self.listings = self.matchOrder(order: self.order, listings: listings)
            self.storageOptionsTbl.reloadData()
        }
        // implement own back button
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
     
    }
    
    func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }

/*************************************************/
/*               Segue Functions                 */
/*************************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeeDetailsSegue" {
            if let destination = segue.destination as? IndividualPriceDisplayVC {
                if let button = sender as? UIButton {
                    destination.priceIndex = storageCompanies[button.tag].getIndividualPrices(order: order)
                }
            }
        }
        
        if segue.identifier == "viewListing" {
            if let destination = segue.destination as? PreviewListingVC, let index = sender as? Int {
                // migrate to all being listings even storage company ones
                if index < storageCompanies.count {
                    
                } else {
                    destination.listing = listings[index - storageCompanies.count]
                }
                destination.order = self.order
            }
        }
    }
    
/*************************************************/
/*            TableView Functions                */
/*************************************************/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewListing", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (storageCompanies.count + listings.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StorageOptionCell", for: indexPath) as? StorageOptionCell {
            if indexPath.row < storageCompanies.count {
                cell.configureCell(company: storageCompanies[indexPath.row], order: order)
            } else {
                cell.configureCell(listing: listings[indexPath.row - storageCompanies.count], order: order)
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
/*        Storage Smart Match Algorithm          */
/*************************************************/
    // come up with the storage algorithm potentially do a bit of research to have some sources to write about the algorithm 
    func matchOrder(order: Order, listings: [Listing]) -> [Listing] {
        func createBlock(objects: [StorableObject]) -> Double {
            var cubicftNeeded = 0.0
            for object in objects {
                if let w = Double(object.width), let l = Double(object.length), let h = Double(object.height) {
                    cubicftNeeded += (l * w * h)/(12.0*12.0*12.0)
                }
            }
            print(cubicftNeeded)
            return cubicftNeeded
        }
        let idealfit = (0.75)*createBlock(objects: order.objects)
        print(idealfit)
        var fitMap = Dictionary<Double, [Listing]>()
        for list in listings {
            if let cbft = Double(list.cubicFeet) {
                let difference = Double.abs((cbft - idealfit))
                if fitMap[difference] != nil {
                    fitMap[difference]?.append(list)
                } else {
                    fitMap[difference] = [list]
                }
            }
        }
        var orderedListings = [Listing]()
        let orderedKeys = fitMap.keys.sorted {
            $0 < $1
        }
        for key in orderedKeys {
            for list in fitMap[key]! {
                orderedListings.append(list)
            }
        }
        return orderedListings
    }
}
