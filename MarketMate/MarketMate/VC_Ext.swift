//
//  VC_Ext.swift
//  MarketMate
//
//  Created by Sean Lohman on 1/14/18.
//  Copyright © 2018 Sean Lohman. All rights reserved.
//

import Foundation
import MapKit

extension ViewController{
    
    // Method to create new annotations and adding them to the map.
    func addMarkets(){
        
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
        
        
        //Creating A Test Market to add to the map
        let testMarket = Market(name: "Test Market", locDescription: "A Test Description", address: "A Test Address", vendors: "15", coordinate: CLLocationCoordinate2D( latitude: 28.5962, longitude: -81.3064))
        //Adding the test market above to the map
        MapKitView.addAnnotation(testMarket)
        
    }
    
}
