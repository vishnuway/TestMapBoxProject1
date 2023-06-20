//
//  PointAnnotationExtension.swift
//  TestMapBox
//
//  Created by Vishnu P on 6/14/23.
//

import Foundation
import MapboxMaps

extension PointAnnotation {
    
    static func userLocationPins(pinCoordinate: CLLocationCoordinate2D) -> PointAnnotation {
        var locationAnnotation = PointAnnotation(coordinate: pinCoordinate)
        locationAnnotation.iconImage = kCurrentLocationPin
        locationAnnotation.iconAnchor = .bottom
        return locationAnnotation
    }
    
    static func serviceLocationPins(pinCoordinate: CLLocationCoordinate2D) -> PointAnnotation {
        var serviceLocationAnnotation = PointAnnotation(coordinate: pinCoordinate)
        serviceLocationAnnotation.iconImage = kDeafultRedFlagImage
        serviceLocationAnnotation.iconAnchor = .bottom
        return serviceLocationAnnotation
    }
}
