//
//  SignUpViewController.swift
//  MarketMate
//
//  Created by Sean Lohman on 1/23/18.
//  Copyright © 2018 Sean Lohman. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    let deviceID = UIDevice.current.identifierForVendor!.uuidString
    var firebaseUser: Firebase.User?
    let userID = Auth.auth().currentUser?.uid
    
    /* IBOUTLETS */
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    /* IBACTIONS */
    @IBAction func SignUp(_ sender: Any) {
        print("signUp Touched")
        
        
        guard let first = firstName.text, let last = lastName.text, let email = emailAddress.text, let pass = password.text
            else {
                print("Invail Form")
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: pass) { (user: User? , error) in
            
            if error != nil{
                print(error!)
                return
            }
            
            //safely unwrapping UID from current User
            guard let uid = Auth.auth().currentUser?.uid else{return}
            
            //successfully authenticated user
            print("Authenticated!")
            var ref: DatabaseReference!
            ref = Database.database().reference().child("users").child(uid)
            
            let values = ["firstname": first, "lastname": last, "email": email]
            ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil{
                    print(err!)
                    return
                }
                self.dismiss(animated: true, completion: nil)
                
                print("Saved user successfully in DB")
            })
            
        }
        
    }

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViewController()
    }
    
    func setupViewController(){
        let uiItems = [signUpButton, firstName, lastName, emailAddress, password,confirmPassword, cancelButton, logo] as [Any]
        
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

    /*
    // MARK: - Firebase Market Adding Code

     ref = Database.database().reference().child("users").child(self.userID).child("markets")
     let market = marketReference.child("Larry's Market")
     let marketValues = ["marketaddress": "101 north test street", "marketName": "Larry's Test Market"]
    */

}
