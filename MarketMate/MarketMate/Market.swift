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
    let coordinate: CLLocationCoordinate2D
    
    //Creating an initializer for the market class
    init(name: String, id: String, address: String, products: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.id = id
        self.address = address
        self.products = products
        self.coordinate = coordinate
        
        super.init()
    }
}
