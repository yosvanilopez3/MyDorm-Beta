//
//  LocationSearchTVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 1/3/17.
//  Copyright © 2017 Yosvani Lopez. All rights reserved.
//

import UIKit
import CoreLocation
class LocationSearchTVC: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    let searchController = UISearchController(searchResultsController: nil)
    var geocoder = CLGeocoder()
    var results = [String]()
    var listing: Listing!
    var region: CLRegion!
    var parentVC: LocationSelectionVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        let deadlineTime = DispatchTime.now() + .nanoseconds(600000000)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.navigationController?.isNavigationBarHidden = true
            self.searchController.searchResultsUpdater = self
            self.searchController.dimsBackgroundDuringPresentation = false
            self.searchController.searchBar.delegate = self
            self.searchController.searchBar.sizeToFit()
            self.tableView.tableHeaderView = self.searchController.searchBar
            self.searchController.searchBar.becomeFirstResponder()
        }
    
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.isNavigationBarHidden = false
        _ = self.navigationController?.popViewController(animated: true)
        if listing.location !=  nil {
            parentVC.listing = listing
            parentVC.searchBar.text = listing.location
        }
    }
    func updateSearchResults(for: UISearchController) {
        if let address = searchController.searchBar.text {
            geocoder.geocodeAddressString(address, in: region) { (placemarks, error) in
                if let marks = placemarks as [CLPlacemark]! {
                    self.results = self.getFormattedAddresses(placemarks:marks)
                    self.tableView.reloadData()
                }
            }
        }
    }

    func getFormattedAddresses(placemarks: [CLPlacemark])-> [String] {
        var addresses = [String]()
        for mark in placemarks {
            if let streetNumber = mark.subThoroughfare, let street = mark.thoroughfare, let city = mark.locality, let state = mark.administrativeArea, let zip = mark.postalCode {
                addresses.append("\(streetNumber) \(street), \(city), \(state) \(zip)")
            }
        }
        return addresses
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "locationCell")
        cell.textLabel?.text = results[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listing.location = results[indexPath.row]
        searchController.isActive = false 
        searchBarCancelButtonClicked(self.searchController.searchBar)
    }
}
