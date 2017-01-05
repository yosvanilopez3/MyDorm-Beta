//
//  ObjectListVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 11/2/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class ObjectListVC: UITableViewController, UISearchResultsUpdating,  UISearchBarDelegate
{
    var allStorableObjects = [StorableObject]()
    var suggestions = [StorableObject]()
    var order: Order!
    var listing: Listing!
    let searchController = UISearchController(searchResultsController: nil)
    var UNWIND_SEGUE: String!
    var parentVC: MovingDataInputVC!
    //add a clear button that erases all the selected objects 
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllObjects()
        let deadlineTime = DispatchTime.now() + .nanoseconds(500000000)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.searchController.searchResultsUpdater = self
            self.searchController.searchBar.delegate = self
            self.searchController.dimsBackgroundDuringPresentation = false
            self.searchController.searchBar.sizeToFit()
            self.tableView.tableHeaderView = self.searchController.searchBar
            self.searchController.searchBar.becomeFirstResponder()
        }
        self.searchController.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        _ = self.navigationController?.popViewController(animated: true)
        parentVC.order = order
    }
    
/*************************************************/
/*           Searchbar Functions                 */
/*************************************************/
    func updateSearchResults(for: UISearchController) {
        if let input = searchController.searchBar.text, input != "" {
            suggestions = allStorableObjects.filter { $0.name.lowercased().contains(input.lowercased())}

        } else {
            suggestions = allStorableObjects
        }
        tableView.reloadData()
    }
    // download them from firebase
    //need to make this thread safe by making get storable objects take a closoure as an arguement
    func loadAllObjects() {
        DataService.instance.getStorableObjects { 
           self.allStorableObjects = DataService.instance.storableObjects
           self.suggestions = self.allStorableObjects
           self.tableView.reloadData()
        }
        
    }
/*************************************************/
/*          TableView Functions                  */
/*************************************************/
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SuggestionCell {
            if let object = cell.object, let h = cell.height.text, h != "", let w = cell.width.text, w != "", let l = cell.length.text, l != "" {
                object.width = w
                object.height = h
                object.length = l
                    DataService.instance.getObjectImage(name: object.name, complete: { (image) in
                        object.image = image
                        self.order.objects.append(object)
                        self.searchController.isActive = false
                        self.searchBarCancelButtonClicked(self.searchController.searchBar)
                    })
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath) as? SuggestionCell {
            cell.configureCell(object: suggestions[indexPath.row], order: order)
            return cell
        }
        return UITableViewCell()
    }
    
}
