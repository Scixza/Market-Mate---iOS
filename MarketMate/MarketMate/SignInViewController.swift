//
//  SignInViewController.swift
//  MarketMate
//
//  Created by Sean Lohman on 1/22/18.
//  Copyright © 2018 Sean Lohman. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    //Member Variables
    var firebaseUser: Firebase.User?
    let userID = Auth.auth().currentUser?.uid
    let googleButton = GIDSignInButton()
    
    /* IBOUTLETS */
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var noAccount: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var uiView: UIView!
    
    /* IBACTIONS */
    @IBAction func back(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
    }
    
    @IBAction func signIn(_ sender: Any) {
        guard let email = emailAddress.text, let password = password.text
            else{
                self.errorHandeling(title: "Don't leave any text fields blank!", message: "Input has detected a blank text field. Make sure your information is correct and try again!", defualt: "ok", cancel: nil)
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {(firebaseUser, error) in
            
            if error != nil {
                self.errorHandeling(title: "Error!", message: "\(String(describing: error?.localizedDescription))", defualt: "ok", cancel: nil)
                return
            }
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UIApplication.shared.endIgnoringInteractionEvents()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        setupViewController()
        self.hideKeyboardWhenTappedAround()
        googleButton.frame = CGRect(x:88, y:575, width: signInButton.frame.width + 40, height: 40)
        googleButton.style = .wide
        view.addSubview(googleButton)
//let margins = view.layoutMarginsGuide
        
//        googleButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
//        googleButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
//        googleButton.heightAnchor.constraint(equalTo: googleButton.widthAnchor, multiplier: 2.0).isActive = true
        
        //googleButton.addConstraint(signInButton.frame.midX)

        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(SignInViewController.noAccountFunction(sender:)))
        
        noAccount.addGestureRecognizer(gesture)
    }

    @objc func noAccountFunction(sender: UITapGestureRecognizer){
        performSegue(withIdentifier: "signUp", sender: self)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if error != nil {
            self.errorHandeling(title: "Error", message: "\(String(describing: error?.localizedDescription))", defualt: "ok", cancel: nil)
            return
        }
        loading()
        
        guard let auth = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil{
                self.errorHandeling(title: "Error", message: "\(error!)", defualt: "ok", cancel: nil)
                return
            }

            if Auth.auth().currentUser == nil{
                //performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
                self.errorHandeling(title: "Error", message: "Failed to authenticate google user", defualt: "ok", cancel: nil)
            }else{
                
                //safely unwrapping information about the current
                guard let uid = Auth.auth().currentUser?.uid else{ return}
                guard let first = Auth.auth().currentUser?.displayName else {return}
                guard let email = Auth.auth().currentUser?.email else {return}
            
                var name = first.split(separator: " ")
                
                if name.count < 2{
                    name.append(name[0])
                }
                
                            var ref: DatabaseReference!
                            ref = Database.database().reference().child("users").child(uid)
                
                            let values = ["firstname": name[0].description, "lastname": name[1].description, "email": email]
                            ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
                                if err != nil{
                                    self.errorHandeling(title: "Error", message: "\(String(describing: error?.localizedDescription))", defualt: "ok", cancel: nil)
                                    return
                                }
                                self.dismiss(animated: false, completion: nil)
                            })
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    //Show loading
    func loading(){
        
        let alert = UIAlertController(title: nil, message: "Logging in...", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.green
        
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.color = UIColor.white
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func setupViewController(){
        let uiItems = [emailAddress, password, logo, signInButton, cancelButton] as [Any]
        
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
    

}
