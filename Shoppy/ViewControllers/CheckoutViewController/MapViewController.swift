//
//  MapViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 20/02/2024.
//

import RxRelay
import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var mappinImageView: UIImageView!
    @IBOutlet var pinView: UIView!
    @IBOutlet var locationContainer: UIView!
    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var locationDetailLabel: UILabel!
    @IBOutlet var confirmButton: UIButton!
    
    var currentLocation: Location?
    var currentPlacemark: Placemark?
    var locationRelay: BehaviorRelay<Location?>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add an address"
        
        setupMapView()
        
        pinView.round(pinView.bounds.width / 2)
        mappinImageView.round(mappinImageView.bounds.width / 2)
        
        locationContainer.round(10)
        locationContainer.addBorder(color: .lightGray, width: 1)
        
        confirmButton.round(10)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
    }
    
    func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsScale = true
        
        setupRegion()
        
        let boundarySpan = MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0)
        let boundaryRegion = MKCoordinateRegion(center: mapView.region.center, span: boundarySpan)
        let cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: boundaryRegion)
        mapView.setCameraBoundary(cameraBoundary, animated: true)
        
        let minZoom = CLLocationDistance(10) // Minimum zoom level (in meters)
        let maxZoom = CLLocationDistance(5000000) // Maximum zoom level (in meters)
        let cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: minZoom, maxCenterCoordinateDistance: maxZoom)
        mapView.setCameraZoomRange(cameraZoomRange, animated: true)
    }
    
    func setupRegion() {
        var center = CLLocationCoordinate2D(latitude: 31.2001, longitude: 29.9187)
        var distance: Double = 5000
        
        if let currentLocation {
            center = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            distance = 0
        }
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let locationPoint = mapView.center
        let coordinate = mapView.convert(locationPoint, toCoordinateFrom: mapView)
        
        currentLocation = Location(clLocation: coordinate)
        updateLocation(coordinate: coordinate)
    }
    
    func updateLocation(coordinate: CLLocationCoordinate2D) {
        reverseGeocodeCoordinate(coordinate: coordinate) { [weak self] placemark in
            self?.currentPlacemark = placemark
            self?.updateUI()
        }
    }
    
    func updateUI() {
        confirmButton.isEnabled = currentLocation != nil
        
        guard let currentPlacemark else {
            locationNameLabel.text = "Unknown"
            locationDetailLabel.text = ""
            return
        }
        
        locationNameLabel.text = currentPlacemark.name
        locationDetailLabel.text = "\(currentPlacemark.throughfare), \(currentPlacemark.administrativeArea), \(currentPlacemark.country)"
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D, completion: @escaping (Placemark) -> Void) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error {
                self?.clearCurrentLocation()
                self?.show(error: error)
                return
            }
            
            guard let placemark = placemarks?.first else {
                self?.clearCurrentLocation()
                self?.showError(title: "Error", message: "Couldn't find any locations")
                return
            }
            
            completion(Placemark(placemark: placemark))
        }
    }
    
    @objc func confirmTapped() {
        currentLocation?.placemark = currentPlacemark
        locationRelay.accept(currentLocation)
        clearCurrentLocation()
        dismiss(animated: true)
    }
    
    func clearCurrentLocation() {
        currentLocation = nil
        updateUI()
    }

}
