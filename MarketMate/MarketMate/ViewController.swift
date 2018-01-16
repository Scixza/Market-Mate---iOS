//
//  ViewController.swift
//  MarketMate
//
//  Created by Sean Lohman on 1/11/18.
//  Copyright © 2018 Sean Lohman. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    /* Member Variables */
    var usda: Array = [Market]()
    var broadMarket: Array = [BroadMarket]()

    /* IBOutlets */
    @IBOutlet weak var MapKitView: MKMapView!
    
    /* IBActions */
    
    /* Methods */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        MapKitView.delegate = self
        //parsing USDA Database
        self.validateAndParseData(zip: "32832")
        
    }
    
    //Requesting Access to users location as well as showing the users location on the map (Updated Info.plist Aswell)
    let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            MapKitView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }

}

extension ViewController: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Market else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}

