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
            guard let uid = self.userID
            else{
                return
            }
            
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
        
        
        //adding a firstname to users
        //ref.child("users").child(deviceID).setValue(["firstname": firstName.text])
        
    }
    
    @IBAction func signUpWithGoogle(_ sender: Any) {
        print("SignUp WIth Google Touched")
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Firebase Market Adding Code

     ref = Database.database().reference().child("users").child(self.userID).child("markets")
     let market = marketReference.child("Larry's Market")
     let marketValues = ["marketaddress": "101 north test street", "marketName": "Larry's Test Market"]
    */

}
