//
//  ViewController.swift
//  Map
//
//  Created by anushkinz on 26/3/22.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    
    let asidMallLocation: Loc = Loc(location: "пр. Чингиза Айтматова 3, Азия Молл Бишкек 750065", name: "Asia Mall")
    let solidLocation: Loc = Loc(location: "Ahunbaeva 119a", name: "Solid academy")
    let neobisLocation: Loc = Loc(location: "98 улица Тыныстанова, Бишкек", name: "Neobis")
    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var MapVC: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkLocationServices()
    }

    private func setupPlacemark(loc: Loc) {
        print(loc.location)
        guard loc.location != nil else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(loc.location) { placemarks, error in
            
            if let error = error{
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = loc.name
            
            
            guard let placemarkLocation = placemark?.location else { return }
            
            annotation.coordinate = placemarkLocation.coordinate
            
            self.MapVC.showAnnotations([annotation], animated: true)
            self.MapVC.selectAnnotation(annotation, animated: true)
        }
    }
    private func checkLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert controller
        }
    }
    private func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            MapVC.showsUserLocation = true
            break
        case .denied:
            // Show alert controller
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("New case is available")
        }
    }

    @IBAction func neobis(_ sender: UIButton) {
        setupPlacemark(loc: neobisLocation)
    }
    @IBAction func solidBtn(_ sender: UIButton) {
        setupPlacemark(loc: solidLocation)
    }
    @IBAction func mallBtn(_ sender: UIButton) {
        setupPlacemark(loc: asidMallLocation)
    }
}


extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
