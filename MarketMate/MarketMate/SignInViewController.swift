//
//  SignInViewController.swift
//  MarketMate
//
//  Created by Sean Lohman on 1/22/18.
//  Copyright © 2018 Sean Lohman. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var noAccount: UILabel!
    @IBOutlet weak var signIn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
//        var ref: DatabaseReference!
//
//        ref = Database.database().reference()
//        
//        ref.updateChildValues(["someValue": 123123])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.noAccountFunction(sender:)))
        
        noAccount.addGestureRecognizer(gesture)
    }

    @objc func noAccountFunction(sender: UITapGestureRecognizer){
        performSegue(withIdentifier: "signUp", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
