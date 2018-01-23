//
//  ViewController.swift
//  MarketMate
//
//  Created by Sean Lohman on 1/11/18.
//  Copyright © 2018 Sean Lohman. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    /* varber Variables */
    var usda: Array = [Market]()
    var broadMarket: Array = [BroadMarket]()
    var initalZip: String = ""
    let locationManager = CLLocationManager()
    
    /* IBOutlets */
    @IBOutlet weak var MapKitView: MKMapView!
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    
    /* IBActions */
    
    /* Methods */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        MapKitView.delegate = self
        locationManager.delegate = self
        //Getting the best accuracy for the user, aswell as starting to track the users location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //initializing hamburger menu
        sideMenu()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        //Setting the Default Zoom radius to 2500 so the user isnt presented with a map of the united states on launch
        let regionRadius: CLLocationDistance = 2500
        let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(myLocation, regionRadius, regionRadius)
        MapKitView.setRegion(coordinateRegion, animated: true)
        
        self.MapKitView.showsUserLocation = true
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil{
                print("Error while trying to reverse geocode zip")
            }else{
                if let place = placemark?[0]{
                    if ("\(String(describing: place.postalCode))") != self.initalZip {
                        print("\(place.postalCode!) is not equal to \(self.initalZip)")
                        self.usda.removeAll()
                        self.validateAndParseData(zip: ("\(place.postalCode!)"))
                        self.initalZip = ("\(place.postalCode!)")
                    }
                    
                    print(place.postalCode!)
                }
                
            }
            
        }
    }
    

}


// creating a callout for each annotation. Works like a table view cell, you have to create one, then deqeue it and reuse it!
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Market else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    //This method gets ran when the information button is pressed on the Annotation's Callout
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let market = view.annotation as! Market
        
        performSegue(withIdentifier: "callout", sender: market)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! CalloutViewController
        
        destination.market = sender as? Market
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
}

