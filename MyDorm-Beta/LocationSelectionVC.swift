//
//  LocationSelectionVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 12/9/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationSelectionVC: UIViewController,   UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    var listing = Listing()
    var geocoder = CLGeocoder()
    var region: CLRegion!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        searchBar.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        geocoder.geocodeAddressString(PRINCETON_ADDRESS, completionHandler: { (placemarks, error) in
                if let marks = placemarks, marks.count > 0 {
                    self.region = marks[0].region
                    let addresses = self.getFormattedAddresses(placemarks: marks)
                    if addresses.count > 0 {
                            self.listing.location = addresses[0]
                        }
                    }
                })
            }
        
        if let uid = UserDefaults.standard.value(forKey: KEY_UID) as? String {
            // come up with more secure way to generate a random id
                listing.uid = uid 
                listing.listingID = "LID\(uid)\(Int(arc4random_uniform(100000000)))"
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
    
    @IBAction func didTapSearchBar(_ sender: AnyObject) {
         performSegue(withIdentifier: "locationSearch", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if listing.location != nil {
            nextBtn.isEnabled = true
            // center on the chosen location 
            // potentially allow them to chose location on map
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last as CLLocation! {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addBasicInfo" {
            if let destination = segue.destination as? SellerBasicInfoVC {
                destination.listing = self.listing 
            }
        }
        if segue.identifier == "locationSearch" {
            if let destination = segue.destination as? LocationSearchTVC {
                destination.listing = self.listing
                destination.region = self.region
                destination.parentVC = self
            }
        }
    }

}
