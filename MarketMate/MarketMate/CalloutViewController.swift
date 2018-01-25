//
//  CalloutViewController.swift
//  MarketMate
//
//  Created by Sean Lohman on 1/19/18.
//  Copyright © 2018 Sean Lohman. All rights reserved.
//
import MapKit
import UIKit
import Firebase

class CalloutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var market: Market! = nil
    var verifiedProducts = [String]()
    var userCurrentList = [String]()

    @IBOutlet weak var marketTitle: UILabel!
    @IBOutlet weak var marketAddress: UILabel!
    @IBOutlet weak var marketHours: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noProducts: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //makes sure everything is loaded when the view DID load
        setup()
        tableView.tableFooterView = UIView()
        
    }
    
    @objc func addressTapped(sender: UITapGestureRecognizer){
        print("address tapped!")
        let placemark = MKPlacemark(coordinate: market.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = market.title
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: MKCoordinateRegionMakeWithDistance(market.coordinate, CLLocationDistance(1000), CLLocationDistance(1000)).center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: MKCoordinateRegionMakeWithDistance(market.coordinate, CLLocationDistance(1000), CLLocationDistance(1000)).span)])
        
    }
    
    func setup(){
        //setting up a gesture recognizer for the address label
        let tapped = UITapGestureRecognizer(target: self, action: #selector(CalloutViewController.addressTapped))
        marketAddress.addGestureRecognizer(tapped)
        marketAddress.isUserInteractionEnabled = true
        
        //setting up the view
        var schedule: String!
        marketTitle.text = market.title
        for i in [";", "<br>"]{
            schedule = market.schedule.replacingOccurrences(of: i, with: "")
        }
        
        if schedule == "    "{
            schedule = "No Operating Hours currently found for market"
            
        }
        
        let hours = schedule.split{$0 == " "}
        
        marketHours.text = "Operating Hours: \n\n \(hours[0]) \(hours[1]) \(hours[2]) \n \(hours[3]) \(hours[4]) \(hours[5]) \(hours[6])"
        marketAddress.text = market.address
        
        divideProducts()
        
        //making the back button up top white
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    func divideProducts(){
        let stringToDivide = market.products.components(separatedBy: "; ")
        
        for product in stringToDivide{
            if !product.isEmpty{
                verifiedProducts.append(product)
            }
        }
        
        if verifiedProducts.count < 1{
            print("Empty Array")
            noProducts.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return verifiedProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "product", for: indexPath)
        
            cell.textLabel?.text = verifiedProducts[indexPath.row]

        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParentViewController {
            
            guard let uid = Auth.auth().currentUser?.uid else{return}
            guard let name = market.title else{return}
            if Auth.auth().currentUser?.uid != nil{
                var ref: DatabaseReference!
                ref =  Database.database().reference().child("users").child(uid).child("list").child(name)
                
                print(ref.key)
            }
            print("Will Move Called")
            
        }
    }
    

    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let addToList = UITableViewRowAction(style: .normal, title: "Add To List") { action, index in
            
            
            guard let productName = tableView.cellForRow(at: index)?.textLabel?.text else {return}

            
            self.userCurrentList.append(productName)
            print("\(productName) added to list")
            print(index.row)
            
        }
        
        addToList.backgroundColor = .green
        
        return [addToList]
    }
    
}
