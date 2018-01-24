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

    
    /* IBOUTLETS */
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    //Button Outlets
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    /* IBACTIONS */
    @IBAction func backButton(_ sender: Any) {
        
    }
    
    @IBAction func EditAccount(_ sender: Any) {
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
    }
    
    @IBAction func signOut(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(logout), with: nil, afterDelay: 0.05)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    

    //Handling User Logout
    @objc func logout(){
        do{ try Auth.auth().signOut() } catch let error{ print(error) }
        performSegue(withIdentifier: "signin", sender: self)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
