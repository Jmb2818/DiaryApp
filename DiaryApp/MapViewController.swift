//
//  MapViewController.swift
//  DiaryApp
//
//  Created by Joshua Borck on 6/4/19.
//  Copyright © 2019 Joshua Borck. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    let annotation = MKPointAnnotation()
    let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        setupGestures()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        focusOnCurrentLocation()
    }
    
    private func setupGestures() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addAnnotationToLocation))
        mapView.addGestureRecognizer(tapRecognizer)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveLocation))
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func focusOnCurrentLocation() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            guard let currentLocation = locationManager.location else {
                return
            }
            
            let coordinateRegion = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            annotation.coordinate = coordinateRegion.center
            
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    @objc private func saveLocation() {
        guard let detailVC = self.navigationController?.viewControllers.first(where: { $0 is DetailViewController }) as? DetailViewController else {
            return
        }
        if locationLabel.text != "Tap To Select A Location" {
            detailVC.model?.creationLocation = locationLabel.text
        }
        navigationController?.popViewController(animated: true)
    }
    
    //TODO: Maybe wrap the geo location in another function
    @objc private func addAnnotationToLocation(sender: UITapGestureRecognizer) {
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let lastLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        geoCoder.reverseGeocodeLocation(lastLocation) { [weak self] placemarks, error in
            guard error == nil else {
                return
            }
            
            if let location = placemarks?.first {
                let city = location.locality ?? ""
                let state = location.administrativeArea ?? ""
                if let street = location.thoroughfare {
                    self?.locationLabel.text = "\(street) - \(city), \(state)"
                } else {
                    self?.locationLabel.text = "\(city), \(state)"
                }
            }
        }
    }
}
