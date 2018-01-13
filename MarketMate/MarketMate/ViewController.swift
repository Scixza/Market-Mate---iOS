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


    /* IBOutlets */
    @IBOutlet weak var MapKitView: MKMapView!
    
    /* IBActions */
    
    /* Methods */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Creating an Initial Location For testing purposes. Initial Location: Full Sail University
        let initialLocation = CLLocation(latitude: 28.5962, longitude: -81.3064)
        
        //Centering Map on the initial location. TO:DO - get the users location and replace hardcoded location in ViewDidLoad
        func centerMapOnLocation(location: CLLocation) {
            //Setting the Default Zoom radius to 1500 so the user isnt presented with a map of the united states on launch
            let regionRadius: CLLocationDistance = 1500
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
            MapKitView.setRegion(coordinateRegion, animated: true)
        }
        
        //Calling Method Created Below
        centerMapOnLocation(location: initialLocation)
    }


}

