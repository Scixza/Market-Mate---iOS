//
//  Annotation.swift
//  MarketMate
//
//  Created by Sean Lohman on 1/17/18.
//  Copyright © 2018 Sean Lohman. All rights reserved.
//

import MapKit

class MarketMarkerView: MKMarkerAnnotationView {
    
    //Customizing the Annotation that is displayed on the map
    override var annotation: MKAnnotation? {
        willSet {
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            markerTintColor = .green
            glyphText = String("M")
        }
    }
}
