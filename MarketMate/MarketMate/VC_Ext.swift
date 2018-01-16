//
//  VC_Ext.swift
//  MarketMate
//
//  Created by Sean Lohman on 1/14/18.
//  Copyright © 2018 Sean Lohman. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

extension ViewController{
    
    // Method to create new annotations and adding them to the map.
    func addMarkets(){
        
        //Creating an Initial Location For testing purposes. Initial Location: Full Sail University
        let initialLocation = CLLocation(latitude: 28.5962, longitude: -81.3064)
        
        //Centering Map on the initial location. TO:DO - get the users location and replace hardcoded location in ViewDidLoad
        func centerMapOnLocation(location: CLLocation) {
            //Setting the Default Zoom radius to 2500 so the user isnt presented with a map of the united states on launch
            let regionRadius: CLLocationDistance = 2500
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
            MapKitView.setRegion(coordinateRegion, animated: true)
        }
        
        //Calling Method Created Below
        centerMapOnLocation(location: initialLocation)
        
        
        //Creating A Test Market to add to the map
        //        let testMarket = Market(name: "Test Market", id: "12", address: "Test Address", products: "Test Products", coordinate: CLLocationCoordinate2D( latitude: 28.5962, longitude: -81.3064))
        //Adding the test market above to the map
        for market in usda{
            MapKitView.addAnnotation(market)
        }
        
    }
    
    //creating function to read in and parse the USDA API https://search.ams.usda.gov/farmersmarkets/v1/svcdesc.html
    func validateAndParseData(zip: String){
        
        //creating a default config
        let config = URLSessionConfiguration.default
        //creating a session with the config
        let session = URLSession(configuration: config)
        //finally verifing URL
        if let validURL = URL(string: "https://search.ams.usda.gov/farmersmarkets/v1/data.svc/zipSearch?zip=" + zip) {
            // setting the task to a data task from the session
            let task = session.dataTask(with: validURL, completionHandler: { (opt_data, opt_response, opt_error) in
                
                //Bail Out on error
                if opt_error != nil { return }
                
                //Check the response, statusCode, and data
                guard let response = opt_response as? HTTPURLResponse,
                    response.statusCode == 200,
                    //setting data to the dataTask Data
                    let data = opt_data
                    else { return }
                print("data set to optdata")
                
                
                
                
                do {
                    //setting json to a serialized json object from the data created and verified from above, setting it to a Any? since it is One large object of json data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as Any? {
                        //digging into the array of posts inside of the big object
                        guard let object = json as? [String: Any],
                            let data = object["results"] as? [Any]
                            else { return }
                        
                        
                        //looping through the array of posts one by one and extracting the author, title, and thumbnail
                        for i in data{
                            guard let market = i as? [String: Any],
                                let id = market["id"] as? String,
                                let name = market["marketname"] as? String
                                else{continue}
                            
                            // adding the Broad Market into the MarketInZip Array
                            self.broadMarket.append(BroadMarket.init(id: id, marketName: name))
                            
                            
                        }
                        
                        for i in self.broadMarket{
                            //creating a default config
                            let config = URLSessionConfiguration.default
                            //creating a session with the config
                            let session = URLSession(configuration: config)
                            //finally verifing URL
                            if let validURL = URL(string: "https://search.ams.usda.gov/farmersmarkets/v1/data.svc/mktDetail?id=" + i.id) {
                                // setting the task to a data task from the session
                                let task = session.dataTask(with: validURL, completionHandler: { (opt_data, opt_response, opt_error) in
                                    
                                    //Bail Out on error
                                    if opt_error != nil { return }
                                    
                                    //Check the response, statusCode, and data
                                    guard let response = opt_response as? HTTPURLResponse,
                                        response.statusCode == 200,
                                        //setting data to the dataTask Data
                                        let data = opt_data
                                        else { return }
                                    print("data set to optdata")
                                    
                                    do {
                                        //setting json to a serialized json object from the data created and verified from above, setting it to a Any? since it is One large object of json data
                                        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as Any? {
                                            //digging into the array of posts inside of the big object
                                            guard let object = json as? [String: Any],
                                                let data = object["marketdetails"] as? [String: Any]
                                                else { return }
                                            
                                            
                                            guard let address = data["Address"] as? String,
                                                let products = data["Products"] as? String,
                                                let schedule = data["Schedule"] as? String
                                                //let coordinateString = data["Address"] as? String
                                                else{return}
                                            
                                            let geocoder = CLGeocoder()
                                            geocoder.geocodeAddressString(address) {
                                                placemarks, error in
                                                let placemark = placemarks?.first
                                                let lat = placemark?.location?.coordinate.latitude
                                                let lon = placemark?.location?.coordinate.longitude
                                                
                                                // adding the Broad Market into the MarketInZip Array
                                                self.usda.append(Market.init(name: i.marketName, id: i.id, address: address, products: products, schedule: schedule, coordinate: CLLocationCoordinate2D( latitude: lat!, longitude: lon!)))
                                                
                                                //Calling Method to Add markets to the MapView
                                                self.addMarkets()
                                            }

                                            
                                        }
                                    } catch  {
                                        print(error.localizedDescription)
                                    }
                                })
                                //resuming the task
                                task.resume()
                            }
                        }
                        
                    }
                } catch  {
                    print(error.localizedDescription)
                }
            })
            //resuming the task
            task.resume()

        }
    }
}


