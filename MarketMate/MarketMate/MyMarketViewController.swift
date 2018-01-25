//
//  MyMarketViewController.swift
//  MarketMate
//
//  Created by Sean Lohman on 1/24/18.
//  Copyright © 2018 Sean Lohman. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class MyMarketViewController: UIViewController {
    
    //Member Variables
    var hasMarket = false
    let rightButton = UIButton.init(type: .custom)
    
    /* IBOUTLETS */
    @IBOutlet weak var noMarketView: UIView!
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var operatingLabel: UILabel!
    @IBOutlet weak var operatingField: UITextView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productField: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    /* IBACTIONS */
    @IBAction func leftBarButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func deleteMarket(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        let ref = Database.database().reference().child("users").child(uid).child("market")
        
        ref.removeValue()
        
        nameField.text?.removeAll()
        addressField.text?.removeAll()
        operatingField.text.removeAll()
        productField.text.removeAll()
        
        print("market deleted")
        
        self.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Making Sure user is logged in
            checkSnapshot()
            //add function for button
            rightButton.setImage(UIImage(named: "Navigation_Add"), for: UIControlState.normal)
            rightButton.addTarget(self, action: #selector(rightButtonClicked), for: UIControlEvents.touchUpInside)
            //set frame
            rightButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            let barButton = UIBarButtonItem(customView: rightButton)
            //assign button to navigationbar
            self.navigationItem.rightBarButtonItem = barButton
        
    }
    
    @objc func rightButtonClicked(){
        if Auth.auth().currentUser?.uid != nil{ // Signed In
            if hasMarket == false{ //Doesnt Have a Market
                
                noMarketView.isHidden = true
                nameLabel.isHidden = false
                nameField.isHidden = false
                addressLabel.isHidden = false
                addressField.isHidden = false
                operatingLabel.isHidden = false
                operatingField.isHidden = false
                productLabel.isHidden = false
                productField.isHidden = false
                deleteButton.isHidden = true
                deleteButton.isEnabled = false
                
                if rightButton.imageView?.image == #imageLiteral(resourceName: "Navigation_Create"){ //Create Market Data
                    print("Creating Market")
                    
                    guard let uid = Auth.auth().currentUser?.uid else {return}
                    guard let name = nameField.text, let address = addressField.text, let hours = operatingField.text, let products = productField.text
                        else{return}
                    
                    let ref = Database.database().reference().child("users").child(uid).child("market")
                    let values = ["name": name, "address": address, "operatinghours": hours, "products": products]
                    ref.updateChildValues(values) { (error, ref) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        print("Added market to Database")
                    }
                    
                    rightButton.setImage(UIImage(named: "Navigation_Edit"), for: UIControlState.normal)
                    checkSnapshot()
                    nameField.isEnabled = false
                    addressField.isEnabled = false
                    operatingField.isEditable = false
                    productField.isEditable = false
                    
                    return
                }else{ // if image is not set to Create
                    rightButton.setImage(UIImage(named: "Navigation_Create"), for: UIControlState.normal)
                    rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                }
                
            }else if hasMarket == true{ // Has Market
                
                
                nameField.isEnabled = true
                addressField.isEnabled = true
                operatingField.isEditable = true
                productField.isEditable = true

                
                if rightButton.imageView?.image == #imageLiteral(resourceName: "Navigation_Save") { // Save Market Data
                    
                    guard let uid = Auth.auth().currentUser?.uid else {return}
                    guard let name = nameField.text, let address = addressField.text, let hours = operatingField.text, let products = productField.text
                        else{return}
                    
                    let ref = Database.database().reference().child("users").child(uid).child("market")
                    let values = ["name": name, "address": address, "operatinghours":hours, "products": products]
                    ref.updateChildValues(values) { (error, ref) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        print("Updated Market in Database")
                    }
                    
                    rightButton.setImage(UIImage(named: "Navigation_Edit"), for: UIControlState.normal)
                    nameField.isEnabled = false
                    addressField.isEnabled = false
                    operatingField.isEditable = false
                    productField.isEditable = false
                    deleteButton.isHidden = true
                    deleteButton.isEnabled = false
                    
                    return
                    
                } else { // Prepare for save Data
                    rightButton.setImage(UIImage(named: "Navigation_Save"), for: UIControlState.normal)
                    deleteButton.isHidden = false
                    deleteButton.isEnabled = true
                }
            
            }
        }else{ //Not Signed in
            performSegue(withIdentifier: "signin", sender: self)
        }
    }
    
    func checkSnapshot(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference(withPath: "users").child(uid).child("market")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if !snapshot.exists() {
                print("Snapshot Doesnt Exist!")
                self.hasMarket = false
                self.setup()
                return
            }
            print ("Snapshot Exists!")
            print (snapshot.value!)
            self.hasMarket = true
            self.setup()
            
            let name = snapshot.childSnapshot(forPath: "name").value as? String
            let address = snapshot.childSnapshot(forPath: "address").value as? String
            let hours = snapshot.childSnapshot(forPath: "operatinghours").value as? String
            let products = snapshot.childSnapshot(forPath: "products").value as? String
            
            self.nameField.text = name
            self.addressField.text = address
            self.operatingField.text = hours
            self.productField.text = products
            
        }
        
    }
    
    func setup(){
        if hasMarket == true { //They have a market
            //set image for button
            rightButton.setImage(UIImage(named: "Navigation_Edit"), for: UIControlState.normal)
            noMarketView.isHidden = true
            nameLabel.isHidden = false
            nameField.isHidden = false
            nameField.isEnabled = false
            addressLabel.isHidden = false
            addressField.isHidden = false
            addressField.isEnabled = false
            operatingLabel.isHidden = false
            operatingField.isHidden = false
            operatingField.isEditable = false
            operatingField.isSelectable = false
            productLabel.isHidden = false
            productField.isHidden = false
            productField.isEditable = false
            productField.isSelectable = false
            
        }else{ //Dont have a market
            //set image for button
            rightButton.setImage(UIImage(named: "Navigation_Add"), for: UIControlState.normal)
        }
    }
    
    
    
    
    
}
