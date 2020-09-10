//
//  Location.swift
//  Live Parking Ghent
//
//  Created by Michiel Leunens on 08/09/2020.
//  Copyright © 2020 Leunes Media. All rights reserved.
//

import CoreLocation
import Foundation
import MapKit

extension Array where Element == Parking {
    func sortedByDistance(to location: CLLocation) -> [Parking] {
        return sorted(by: { location.distance(from: CLLocation(latitude: $0.geo_location![0], longitude: $0.geo_location![1])) < location.distance(from: CLLocation(latitude: $1.geo_location![0], longitude: $1.geo_location![1])) })
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
