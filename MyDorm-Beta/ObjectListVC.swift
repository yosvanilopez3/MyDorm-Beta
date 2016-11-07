//
//  ObjectListVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 11/2/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit

class ObjectListVC: UIViewController, UITableViewDelegate,
  UITableViewDataSource, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var suggestionTable: UITableView!
    @IBOutlet weak var selectedCollection: UICollectionView!
    var allStorableObjects: [StorableObject]!
    var suggestions = [StorableObject]()
    var selectedObjects = [StorableObject]()
    
    //add a clear button that erases all the selected objects 
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        searchBar.delegate = self
        suggestionTable.delegate = self
        suggestionTable.dataSource = self
        selectedCollection.delegate = self
        selectedCollection.dataSource = self
        loadAllObjects()
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let parentVC = viewController as? MovingDataInputVC {
            parentVC.selectedObjects = selectedObjects
        }
    }
/*************************************************/
/*           Searchbar Functions                 */
/*************************************************/
    // sort by most selected objects use user logged data to compute this
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        suggestions = allStorableObjects.filter { $0.name.lowercased().contains(searchText.lowercased())}
        self.suggestionTable.reloadData()
    }
    
    // download them from firebase 
    //need to make this thread safe by making get storable objects take a closoure as an arguement
    func loadAllObjects() {
        DataService.instance.getStorableObjects { 
           self.allStorableObjects = DataService.instance.storableObjects
           self.suggestions = self.allStorableObjects
           self.suggestionTable.reloadData()
        }
    }
/*************************************************/
/*          TableView Functions                  */
/*************************************************/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedObject = suggestions[indexPath.row]
        selectedObjects.append(selectedObject)
        selectedCollection.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 18.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath) as? SuggestionCell {
            let object = suggestions[indexPath.row]
            cell.configureCell(name: object.name, detail: "details")
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
/*************************************************/
/*          CollectionView Functions             */
/*************************************************/
    //build the collection from the center outward 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedCell", for: indexPath) as? SelectedObjectCell {
            let object = selectedObjects[indexPath.row]
            cell.configureCell(name: object.name, detail: "details")
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deleteCellFromCollection), for: .touchUpInside)
            return cell
        }
        return UICollectionViewCell()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func deleteCellFromCollection(deleteBtn: UIButton) {
        selectedObjects.remove(at: deleteBtn.tag)
        selectedCollection.reloadData()
    }

}
