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
import Firebase


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate {
    
    /* varber Variables */
    var usda: Array = [Market]()
    var broadMarket: Array = [BroadMarket]()
    var initalZip: String = ""
    let locationManager = CLLocationManager()
    var tapped = false
    //lazy var searchBar = UISearchBar(frame: CGRect.zero)
    var searchOn = false
    
    //Testing
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    
    
    /* IBOutlets */
    @IBOutlet weak var MapKitView: MKMapView!
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    /* IBActions */
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
    @IBAction func search(_ sender: Any) {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        searchController.searchBar.keyboardType = .namePhonePad
        present(searchController, animated: true, completion: nil)
    }
    
    /* Methods */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //presenting loading screen while map loads
        loading()
        MapKitView.delegate = self
        locationManager.delegate = self
        //Getting the best accuracy for the user, aswell as starting to track the users location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //MapKitView.mapType = .hybrid
        //initializing hamburger menu
        sideMenu()
        }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        //Setting the Default Zoom radius to 2500 so the user isnt presented with a map of the united states on launch
        let regionRadius: CLLocationDistance = 3500
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
                        self.validateAndParseUserMarkets(zipcode: ("\(place.postalCode!)"))
                        
                    }
                    
                }
                
            }
            
        }
    }
    
    func validateAndParseUserMarkets(zipcode: String){
        //guard let uid = Auth.auth().currentUser?.uid else{return}
        
        let ref = Database.database().reference(withPath: "markets").child(zipcode)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if !snapshot.exists(){
                print("snapshot doesnt exist")
                return
            }
            print("Snapshot Exists!")
            print(snapshot.value!)
            
            for child in snapshot.children{
                let child = child as! DataSnapshot
                let address = child.childSnapshot(forPath: "address").value as? String
                let name = child.childSnapshot(forPath: "name").value as? String
                let hours = child.childSnapshot(forPath: "operatinghours").value as? String
                let items = child.childSnapshot(forPath: "products").value as? String
                //let zip = child.childSnapshot(forPath: "zip").value as? String
                
                
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(address!) {
                    placemarks, error in
                    
                    if error != nil {
                        print("Error gathering address Validate Firebase \(error!)")
                    }else{
                        let placemark = placemarks?.first
                        let lat = placemark?.location?.coordinate.latitude
                        let lon = placemark?.location?.coordinate.longitude
                        
                        self.usda.append(Market(name: name!, id: nil, address: address!, products: items!, schedule: hours!, coordinate: CLLocationCoordinate2D(latitude: lat!, longitude: lon!)))
                        
                        self.addMarkets()
                    }
                    
                }
            }
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Error Finding Zipcode", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            self.MapKitView.centerCoordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            self.validateAndParseUserMarkets(zipcode: searchBar.text!)
            self.validateAndParseData(zip: searchBar.text!)
            
        }
    }
    
    
    func loading(){
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.green
        
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.color = UIColor.white
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    

}


// creating a callout for each annotation. Works like a table view cell, you have to create one, then deqeue it and reuse it!
extension ViewController {
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

