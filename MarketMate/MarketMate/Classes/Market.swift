//
//  Market.swift
//  MarketMate
//
//  Created by Sean Lohman on 1/13/18.
//  Copyright © 2018 Sean Lohman. All rights reserved.
//

import Foundation
import MapKit

//Creating a Custom Class to House all the Information About each market.
class Market: NSObject, MKAnnotation{
    //Variables of the Market Class
    let name: String?
    let id: String
    let products: String
    let address: String?
    let schedule: String
    let coordinate: CLLocationCoordinate2D
    
    //Creating an initializer for the market class
    init(name: String, id: String, address: String, products: String, schedule: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.id = id
        self.address = address
        self.products = products
        self.schedule = schedule
        self.coordinate = coordinate
        
        super.init()
    }
    
    //Annotations need a "Title" In our case its the name of the farmers market
    var title: String? {
        return name
    }
    //Annotations also need a Subtitle, we'll use addres
    var subtitle: String? {
        return address
    }
}
