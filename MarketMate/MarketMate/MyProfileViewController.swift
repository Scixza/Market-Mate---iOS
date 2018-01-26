//
//  MyProfileViewController.swift
//  MarketMate
//
//  Created by Sean Lohman on 1/22/18.
//  Copyright © 2018 Sean Lohman. All rights reserved.
//

import UIKit
import Firebase

class MyProfileViewController: UIViewController {

    var firebaseUser: Firebase.User?
    let userID = Auth.auth().currentUser?.uid
    let auth = Auth.auth()
    var snapshot: DataSnapshot?
    
    /* IBOUTLETS */
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    //Button Outlets
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    
    /* IBACTIONS */
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func EditAccount(_ sender: Any) {
        editButton.isEnabled = false
        editButton.isHidden = true
        saveButton.isHidden = false
        saveButton.isEnabled = true
        cancelButton.isHidden = false
        cancelButton.isEnabled = true
        emailAddress.isEnabled = true
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        editButton.isHidden = false
        editButton.isEnabled = true
        cancelButton.isHidden = true
        cancelButton.isEnabled = false
        saveButton.isHidden = true
        saveButton.isEnabled = false
        emailAddress.isEnabled = false
        databasePull()
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let email = emailAddress.text else{return}
        
        let ref = Database.database().reference().child("users").child(uid)
        let values = ["email": email]
        ref.updateChildValues(values) { (error, ref) in
            if error != nil{
                self.errorHandeling(title: "Error", message: error as! String, defualt: "ok", cancel: nil)
                return
            }
            print("Updated user in Database")
        }
        
        editButton.isHidden = false
        editButton.isEnabled = true
        cancelButton.isHidden = true
        cancelButton.isEnabled = false
        saveButton.isHidden = true
        saveButton.isEnabled = false
        emailAddress.isEnabled = false
    }
    
    @IBAction func signOut(_ sender: Any) {
        emailAddress.text?.removeAll()
        firstName.text?.removeAll()
        lastName.text?.removeAll()
        logout()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViewController()
        if Auth.auth().currentUser?.uid == nil{
            //UIApplication.shared.beginIgnoringInteractionEvents()
            perform(#selector(logout), with: nil, afterDelay: 0.1)
        }else{
            //UIApplication.shared.endIgnoringInteractionEvents()

            //dismissing loading View
            //self.dismiss(animated: false, completion: nil)
        }
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        databasePull()
    }
    
    func databasePull(){
        if Auth.auth().currentUser?.uid != nil {
        let uid = auth.currentUser?.uid
        
        let ref = Database.database().reference(withPath: "users").child(uid!)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }

            let email = snapshot.childSnapshot(forPath: "email").value as? String
            let first = snapshot.childSnapshot(forPath: "firstname").value as? String
            let last = snapshot.childSnapshot(forPath: "lastname").value as? String
            
            self.firstName.text = first
            self.lastName.text = last
            self.emailAddress.text = email
            
            print(snapshot.value!)
            
        })}
    }
    
    func setupViewController(){
        let uiItems = [firstName, lastName, emailAddress, editButton, cancelButton, saveButton, signOutButton] as [Any]
        
        //Looping through UI items, and setting a drop shadow on them, and rounded corners
        for i in uiItems{
            (i as AnyObject).layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            (i as AnyObject).layer.shadowOffset = CGSize(width: 0, height: 3.0)
            (i as AnyObject).layer.shadowOpacity = 1.0
            (i as AnyObject).layer.shadowRadius = 0.0
            (i as AnyObject).layer.masksToBounds = false
            (i as AnyObject).layer.cornerRadius = 6.0
        }
    }
    
    func errorHandeling(title: String, message: String, defualt: String, cancel: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: defualt, style: .default, handler: nil))
        if cancel != nil{
            alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        }
        
        self.present(alert, animated: true)
    }
    
    
    //Handling User Logout
    @objc func logout(){
        do{ try Auth.auth().signOut() } catch let error{ self.errorHandeling(title: "Error", message: error as! String, defualt: "ok", cancel: nil) }
        performSegue(withIdentifier: "signin", sender: self)
    }
}
