//
//  AddressSearchVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 12/11/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit
import MapKit
class AddressSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var searchResults = [MKMapItem]()
    var mapView: MKMapView!
    var listing: Listing!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        
        
    }
  
/*************************************************/
/*          TableView Functions                  */
/*************************************************/

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(searchResults.count, 8)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StandardTextCell", for: indexPath) as? StandardTextCell {
            let address = searchResults[indexPath.row]
            cell.configureCell(text: getaddress(place: address))
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchResults.count > indexPath.row {
            listing.location = searchResults[indexPath.row].name
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func getaddress(place: MKMapItem)-> String {
        //need to add steps to handle possible conditionals more smoothly rather than explicitly using !
        
        if let dictionary = place.placemark.addressDictionary {
            print(dictionary)
            if let addressLines = dictionary["FormattedAddressLines"] as? [String] {
                return addressLines.joined(separator: " ")
            }
        }
        // find better handle for when the place doesnt have a valid name 
        return place.name!
    }
/*************************************************/
/*           Searchbar Functions                 */
/*************************************************/
    // sort by most selected objects use user logged data to compute this
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        LoadAddresses(query: searchText)
        tableView.reloadData()
        self.reloadInputViews()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func LoadAddresses(query: String) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {(response, error) in
            
            if error != nil {
                print("Error occured in search:\(error!.localizedDescription)")
                
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                var addresses = [MKMapItem]()
                for item in response!.mapItems {
                    if let _ = item.name as String! {
                        addresses.append(item)
                    }
                self.searchResults = addresses
                }
            }
        })
    }
}
