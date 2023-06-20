//
//  ViewController.swift
//  TestMapBox
//
//  Created by Vishnu P on 6/14/23.
//

import UIKit
import MapboxMaps

let kCurrentLocationPin: String = "ic_location_search"
let kDeafultRedFlagImage: String = "ic_search_flag"
let userAnnotationID: String = "UserAnnotationFlag"
let shopAnnotationID: String = "ShopAnnotationFlag"

enum AnnotationPointViewPinType: String {
    case userLocation = "userLocation"
    case shopLocation = "shopLocation"
}

class ViewController: UIViewController, AnnotationInteractionDelegate {
    func annotationManager(_ manager: MapboxMaps.AnnotationManager, didDetectTappedAnnotations annotations: [MapboxMaps.Annotation]) {
        let listOfAnnotation = annotations
        for pin in listOfAnnotation {
            if pin.id == AnnotationPointViewPinType.userLocation.rawValue {
                print("User location Tapped")
            } else{
                print("Shop location Tapped")
            }
        }
    }
    
    
    @IBOutlet weak var mapUIView: UIView!
    
    let locationManager = CLLocationManager()
    var latitude: Double?
    var longitude: Double?
    var coordinate: CLLocationCoordinate2D?
    var pointAnnotationManager: PointAnnotationManager?
    var currentAnnotationMangerId: String?
    var mapView: MapView!
    var annotationPinView: UserLocationPinView?
    var annotationArray: [PointAnnotation]?
    var locationArray = [LocationCoordinate2D(latitude: 8.549788, longitude: 76.899910), LocationCoordinate2D(latitude: 8.548090, longitude: 76.924646), LocationCoordinate2D(latitude: 8.541300, longitude: 76.876892)]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async { [self] in
              if CLLocationManager.locationServicesEnabled() {
                  locationManager.delegate = self
                  locationManager.desiredAccuracy = kCLLocationAccuracyBest
                  locationManager.startUpdatingLocation()
              }
        }
    }
    
    func initialFunctionsForMapbox() {
        let options = MapInitOptions(cameraOptions: CameraOptions(center: coordinate, zoom: 13))
        
        mapView = MapView(frame: mapUIView.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapUIView.addSubview(mapView)
        pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        pointAnnotationManager?.delegate = self
        mapView.mapboxMap.onNext(event: .mapLoaded) { [weak self] _ in
            guard let self = self else { return }
            self.prepareStyle()
            
        }
//        let coordinate = CLLocationCoordinate2DMake(24, -89)
//        var pointAnnotation = PointAnnotation(coordinate: coordinate)
//        pointAnnotation.id
        
    }
    
    func generatePointAnnotationPins(lat: Double, long: Double, pinType: AnnotationPointViewPinType) -> PointAnnotation {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        var pointAnnotation = PointAnnotation(coordinate: coordinate)
        switch pinType {
        case .userLocation:
            pointAnnotation.image = .init(image: UIImage(named: "ic_search_flag")!, name: userAnnotationID)
        case .shopLocation:
            pointAnnotation.image = .init(image: UIImage(named: "ic_location_search")!, name: shopAnnotationID)
        }
        
        return pointAnnotation
    }
    
    func prepareStyle() {
        pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        pointAnnotationManager?.delegate = self
        for location in 0 ..< locationArray.count {
            if location == 0 {
                annotationArray?.append(generatePointAnnotationPins(lat: locationArray[location].latitude, long: locationArray[location].longitude, pinType: .userLocation))
            } else {
                annotationArray?.append(generatePointAnnotationPins(lat: locationArray[location].latitude, long: locationArray[location].longitude, pinType: .shopLocation))
            }
        }
        pointAnnotationManager?.annotations = annotationArray ?? []
        
        let options = ViewAnnotationOptions(
            allowOverlap: true, visible: true, anchor: .center
        )
        
        let annotView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        annotView.backgroundColor = .red
        try? mapView.viewAnnotations.add(annotView, options: options)
//        try? mapView.addanno
//        mapView.addann
    }
    
//    func generateAnnotationView(pinType: AnnotationPointViewPinType) -> UIView {
//        switch pinType {
//        case .userLocation:
//            let userPinView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//            let pinImage = UIImage(named: "ic_search_flag")
//            let pinImageView = UIImageView(image: pinImage)
//            userPinView.addSubview(pinImageView)
////            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userLocationAnnotationTapped(_:)))
////            pinImageView.isUserInteractionEnabled = true
////            pinImageView.addGestureRecognizer(tapGesture)
//            return userPinView
//        case .shopLocation:
//            let shopPinView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//            let shopImage = UIImage(named: "ic_location_search")
//            let shopImageView = UIImageView(image: shopImage)
//            shopPinView.addSubview(shopImageView)
////            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(shopLocationAnnotationTapped(_:)))
////            shopPinView.isUserInteractionEnabled = true
////            shopPinView.addGestureRecognizer(tapGesture)
//            return shopPinView
//        }
//    }
    
    func addAnnotation(at coordinate: CLLocationCoordinate2D, userType: AnnotationPointViewPinType) {
        annotationArray?.append(PointAnnotation(coordinate: coordinate))
        let options = ViewAnnotationOptions(
            geometry: Point(coordinate),
            allowOverlap: true,
            anchor: .center
        )
//        let annotationView = generateAnnotationView(pinType: userType)
        pointAnnotationManager?.annotations = annotationArray ?? []
//        try? mapView.viewAnnotations.add(annotationView, options: options)
    }
    
    @objc func userLocationAnnotationTapped(_ sender: UITapGestureRecognizer? = nil) {
        print("User Location Tapped")
        let annotationOnMap = mapView.viewAnnotations.annotations
        
    }
    
    @objc func shopLocationAnnotationTapped(_ sender: UITapGestureRecognizer? = nil) {
        print("Shop Location Tapped")
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        coordinate = locValue
        latitude = locValue.latitude
        longitude = locValue.longitude
        initialFunctionsForMapbox()
    }
}

