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

