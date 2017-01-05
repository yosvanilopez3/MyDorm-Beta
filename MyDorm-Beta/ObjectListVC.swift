//
//  ObjectListVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 11/2/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class ObjectListVC: UITableViewController, UISearchResultsUpdating, UINavigationControllerDelegate
{
    var allStorableObjects = [StorableObject]()
    var suggestions = [StorableObject]()
    var order: Order!
    var listing: Listing!
    let searchController = UISearchController(searchResultsController: nil)
    var UNWIND_SEGUE: String!
    //add a clear button that erases all the selected objects 
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        loadAllObjects()
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.searchController.searchResultsUpdater = self
            self.searchController.hidesNavigationBarDuringPresentation = true
            self.hidesBottomBarWhenPushed = true
            self.searchController.dimsBackgroundDuringPresentation = false
            self.searchController.searchBar.sizeToFit()
            self.tableView.tableHeaderView = self.searchController.searchBar
            self.searchController.searchBar.becomeFirstResponder()
        }
    }

    @IBAction func doneBtn(_ sender: AnyObject) {
        performSegue(withIdentifier: UNWIND_SEGUE, sender: nil)
    }
/*************************************************/
/*           Searchbar Functions                 */
/*************************************************/
    func updateSearchResults(for: UISearchController) {
        if let input = searchController.searchBar.text {
            suggestions = allStorableObjects.filter { $0.name.lowercased().contains(input.lowercased())}
            tableView.reloadData()
        }
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedObject = suggestions[indexPath.row]
        order.objects.append(selectedObject)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath) as? SuggestionCell {
            cell.configureCell(object: suggestions[indexPath.row], order: order, parent: self)
            return cell
        }
        return UITableViewCell()
    }
    
}
