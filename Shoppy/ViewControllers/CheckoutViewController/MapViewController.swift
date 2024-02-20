//
//  MapViewController.swift
//  Shoppy
//
//  Created by Azoz Salah on 20/02/2024.
//

import MapKit
import UIKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var pinView: UIView!
    @IBOutlet var locationContainer: UIView!
    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var locationDetailLabel: UILabel!
    @IBOutlet var confirmButton: UIButton!
    
    var currentLocation: Placemark!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add an address"
        
        setupMapView()
        
        pinView.round(pinView.bounds.width / 2)
        
        locationContainer.round(10)
        locationContainer.addBorder(color: .lightGray, width: 1)
    }
    
    func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsScale = true
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let locationPoint = mapView.center
        let coordinate = mapView.convert(locationPoint, toCoordinateFrom: mapView)
        
        updateLocation(coordinate: coordinate)
    }
    
    func updateLocation(coordinate: CLLocationCoordinate2D) {
        reverseGeocodeCoordinate(coordinate: coordinate) { [weak self] placemark in
            self?.currentLocation = placemark
            
            self?.locationNameLabel.text = placemark.name
            self?.locationDetailLabel.text = "\(placemark.throughfare), \(placemark.administrativeArea), \(placemark.country)"
        }
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
    
    func clearCurrentLocation() {
        currentLocation = Placemark.unknown
        locationNameLabel.text = "Unknown"
        locationDetailLabel.text = ""
    }

}
