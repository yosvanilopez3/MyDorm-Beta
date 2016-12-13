//
//  LocationSelectionVC.swift
//  MyDorm-Beta
//
//  Created by Yosvani Lopez on 12/9/16.
//  Copyright © 2016 Yosvani Lopez. All rights reserved.
//

import UIKit
import MapKit
class LocationSelectionVC: UIViewController,  CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var currentLocationLbl: UILabel!
    var listing = Listing()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        // Ask for Authorization from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            // change this to be geocoding of userloaction
            currentLocationLbl.text = mapView.userLocation.title
            listing.Location = MKPlacemark(coordinate: mapView.userLocation.coordinate)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if listing.Location != nil {
            nextBtn.isEnabled = true
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
        // functional passing of Listing
        if segue.identifier == "goToAddressSearch" {
            if let destination = segue.destination as? AddressSearchVC {
                destination.mapView = self.mapView
                destination.listing = self.listing
            }
        }
        if segue.identifier == "goToSellerBasicInfo" {
            if let destination = segue.destination as? SellerBasicInfoVC {
                destination.listing = self.listing 
            }
        }
    }
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        // functional retrieval of Listing 
        if unwindSegue.identifier == "goToAddressSearch" {
            if let source = unwindSegue.source as? AddressSearchVC {
                self.listing = source.listing
                // change this to use geocoding
                self.currentLocationLbl.text = source.listing.Location?.countryCode
            }
        }
    }
    
    @IBAction func goToMyLocationBtn(_ sender: AnyObject) {
    }
    @IBAction func cancelBtnPressed(_ sender: AnyObject) {
    }

}
