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
        
        //showing user location on the map
        //MapKitView.showsUserLocation = true
        
        //parsing USDA Database
        self.validateAndParseData(zip: "32832")
        
        //Calling Method to Add markets to the MapView
        self.addMarkets()
        
        //Requestion Access to user Location When the app needs it
        //self.requestLocation()
    }

}

