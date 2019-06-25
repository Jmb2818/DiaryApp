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
    
    // MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabelView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var refreshLocationButton: UIButton!
    
    
    // MARK: Properties
    private let locationManager = CLLocationManager()
    private let regionRadius: CLLocationDistance = 1000
    private let annotation = MKPointAnnotation()
    private let geoCoder = CLGeocoder()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        setupGestures()
        setUpLocationView()
        setupNavigationBar()
        setupRefreshButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        focusOnCurrentLocation()
    }
    
    // MARK: IBActions
    @IBAction func refeshLocation(_ sender: UIButton) {
        focusOnCurrentLocation()
    }
    
    // MARK: Actions
    /// Save the currently selected location if it exists
    @objc private func saveLocation() {
        guard let detailVC = self.navigationController?.viewControllers.first(where: { $0 is DetailViewController }) as? DetailViewController else {
            return
        }
        if locationLabel.text != UserStrings.Location.selectALocation {
            detailVC.model?.creationLocation = locationLabel.text
        }
        navigationController?.popViewController(animated: true)
    }
    
    /// Add a pin to the map when user taps it
    @objc private func addAnnotationToLocation(sender: UITapGestureRecognizer) {
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let lastLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        // Convert the last location into a readable location for user
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

// MARK: CLLocationManagerDelegate Conformance
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        focusOnCurrentLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let error = DiaryError.locationError
        presentAlert(title: error.errorTitle, message: error.errorMessage)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            focusOnCurrentLocation()
        default:
            break
        }
    }
}

// MARK: View Setup
private extension MapViewController {
    func setUpLocationView() {
        locationLabelView.clipsToBounds = true
        locationLabelView.layer.cornerRadius = 20
        locationLabelView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func setupRefreshButton() {
        refreshLocationButton.layer.masksToBounds = false
        refreshLocationButton.layer.cornerRadius = 0.5 * refreshLocationButton.bounds.size.width
        refreshLocationButton.clipsToBounds = true
    }
    
    func setupGestures() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addAnnotationToLocation))
        mapView.addGestureRecognizer(tapRecognizer)
    }
    
    func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveLocation))
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    /// Funcion to zoom in on users current location if permission has been given
    func focusOnCurrentLocation() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            guard let currentLocation = locationManager.location else {
                locationManager.requestLocation()
                return
            }
            
            let coordinateRegion = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            annotation.coordinate = coordinateRegion.center
            
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
}
