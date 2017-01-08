//
//  MovingDataInputVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 10/18/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit
import Foundation
import PDTSimpleCalendar
class MovingDataInputVC: UIViewController, PDTSimpleCalendarViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var pickupDateLbl: UIButton!
    @IBOutlet weak var dropoffDateLbl: UIButton!
    @IBOutlet weak var selectedCollection: UICollectionView!
    // potentially use two different calenders or set identifier to distinguish between dropoff and pickup dates
    var calender = PDTSimpleCalendarViewController()
    var order: Order!
    override func viewDidLoad() {
        super.viewDidLoad()
        calender.delegate = self
        order = Order()
        if let uid = UserDefaults.standard.value(forKey: KEY_UID) as? String {
            // come up with more secure way to generate a random id
            order.uid = uid
            order.orderID = "OID\(uid)\(Int(arc4random_uniform(100000000)))"
        }
        // set the date labels
        pickupDateLbl.setTitle("MM/DD/YYYY", for: UIControlState.normal)
        dropoffDateLbl.setTitle("MM/DD/YYYY", for: UIControlState.normal)
        selectedCollection.delegate = self
        selectedCollection.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        selectedCollection.reloadData()
        print(order.objects.count)
    }
/*************************************************/
/*            Date Set Functions                 */
/*************************************************/
 
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, didSelect date: Date!) {
        if controller.accessibilityLabel == "pickup" {
                order.pickup = date
                pickupDateLbl.setTitle(date.formatDate(), for: UIControlState.normal)
        }
        if controller.accessibilityLabel == "dropoff" {
                order.dropoff = date
             dropoffDateLbl.setTitle(date.formatDate(), for: UIControlState.normal)
        }
        self.dismiss(animated: true, completion: nil)
    }

/*************************************************/
/*                Segue Controls                 */
/*************************************************/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChooseObjects" {
            if let destination = segue.destination as? ObjectListVC {
                destination.order = order
                destination.parentVC = self
            }
        }
        else if segue.identifier == "PriceDisplay" {
            if let destination = segue.destination as? PriceDisplayVC {
                destination.order = order
            }
        }
    }
    @IBAction func addItemsBtnPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "ChooseObjects", sender: nil)
    }
    @IBAction func selectPickup(_ sender: AnyObject) {
        calender.accessibilityLabel = "pickup"
        present(calender, animated: true, completion: nil)
    }
    
    @IBAction func selectDropOff(_ sender: AnyObject) {
        calender.accessibilityLabel = "dropoff"
        present(calender, animated: true, completion: nil)
    }
    @IBAction func unwindToMoving(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindFromChooseObjects" {
            if let source = segue.source as? ObjectListVC {
                self.order = source.order
                self.selectedCollection.reloadData()
            }
        }
    }
    
/*************************************************/
/*            Utility Functions                  */
/*************************************************/

    func getNameList() -> String {
        var list = ""
        for object in order.objects {
            if list.isEmpty {
                list = "\(object.name)"
            }
            else {
                list = "\(list), \(object.name)"
            }
        }
        return list
    }
    
/*************************************************/
/*          CollectionView Functions             */
/*************************************************/
    //build the collection from the center outward
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return order.objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedCell", for: indexPath) as? SelectedObjectCell {
            cell.configureCell(object: order.objects[indexPath.row], detail: "details")
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
        order.objects.remove(at: deleteBtn.tag)
        selectedCollection.reloadData()
    }
    

   }
