//
//  ParkingDetailViewController.swift
//  Live Parking Ghent
//
//  Created by Michiel Leunens on 08/09/2020.
//  Copyright © 2020 Leunes Media. All rights reserved.
//

import MapKit
import UIKit

class ParkingDetailViewController: UIViewController {
    var selectedParking: Parking?
    weak var delegate: ParkingListViewController!
    var safeArea: UILayoutGuide!
    var mapView = MKMapView()

    let nameLabel = UILabel()
    let addressLabel = UILabel()
    let contactLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = view.layoutMarginsGuide
        view.backgroundColor = UIColor.white
        setupNameLabel()
        setupAddressLabel()
        setupContactLabel()
        setupMapView()
    }

    func setupNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 32).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        nameLabel.font = UIFont(name: "Nunito-Bold", size: 16)
        nameLabel.text = selectedParking?.name
    }

    func setupAddressLabel() {
        view.addSubview(addressLabel)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        addressLabel.text = selectedParking?.address
    }

    func setupContactLabel() {
        view.addSubview(contactLabel)
        contactLabel.translatesAutoresizingMaskIntoConstraints = false
        contactLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8).isActive = true
        contactLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        contactLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        contactLabel.text = selectedParking?.contactinfo
    }

    func setupMapView() {
        view.addSubview(mapView)

        let initialLocation = CLLocation(latitude: (selectedParking?.geo_location?[0])!, longitude: (selectedParking?.geo_location?[1])!)
        mapView.centerToLocation(initialLocation)
        let parkingAnnotation = MKPointAnnotation()
        parkingAnnotation.title = selectedParking?.name
        parkingAnnotation.coordinate = CLLocationCoordinate2D(latitude: (selectedParking?.geo_location?[0])!, longitude: (selectedParking?.geo_location?[1])!)
        mapView.addAnnotation(parkingAnnotation)
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: contactLabel.bottomAnchor, constant: 8).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

extension ParkingDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "parking")

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "parking")
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
}
