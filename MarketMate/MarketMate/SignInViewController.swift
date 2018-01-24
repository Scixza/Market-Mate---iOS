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
    
    /* IBOUTLETS */
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var noAccount: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    /* IBACTIONS */
    @IBAction func back(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
    }
    
    @IBAction func signIn(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.noAccountFunction(sender:)))
        
        noAccount.addGestureRecognizer(gesture)
    }

    @objc func noAccountFunction(sender: UITapGestureRecognizer){
        performSegue(withIdentifier: "signUp", sender: self)
    }

}
