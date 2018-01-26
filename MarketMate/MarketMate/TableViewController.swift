//
//  TableViewController.swift
//  MarketMate
//
//  Created by Sean Lohman on 1/25/18.
//  Copyright © 2018 Sean Lohman. All rights reserved.
//

import UIKit
import Firebase

class TableViewController: UITableViewController {
    
    
    /* Member Variables */
    var numOfMarkets = [String]()
    var products = [String]()
    var clickedMarketName = String()
    
    /* IBACTIONS */
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser?.uid != nil {
            guard let uid = Auth.auth().currentUser?.uid else{return}
            let ref = Database.database().reference(withPath: "users").child(uid).child("list")
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if !snapshot.exists(){
                    print("Snapshot Doesnt Exist!")
                    self.errorHandeling(title: "No Products Found", message: "You must first add products to the list, by navigating to the map, finding a market, and sliding on a product!", defualt: "Ok", cancel: nil)
                    return
                }
                print("Snapshot Exists!")
                print(snapshot.value!)
                
                
                for child in snapshot.children{
                    let snap = child as! DataSnapshot
                    let marketName = snap.key

                    self.numOfMarkets.append(marketName)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            })

        }else{
             self.errorHandeling(title: "Not Signed in!", message: "You must first sign in to add products to the list, after you sign in you can add items by navigating to the map, finding a market, and sliding on a product!", defualt: "Ok", cancel: nil)
        }
    }
    
    func grabData(i: String){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference(withPath: "users").child(uid).child("list").child(i)
        
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if !snapshot.exists(){return}
            
            print(snapshot.value!)
            
            let rawProduct = snapshot.value as! Dictionary<String, String>
            
            print(rawProduct)
            
            var test = ["<null>"]
            
            for (_, product) in rawProduct{
                test.append(product)
            }

            for i in test{
                if i != "<null>"{
                    self.products.append(i)
                }
            }
        }
    }

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numOfMarkets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = numOfMarkets[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //loading()
        print("\(numOfMarkets[indexPath.row]) tapped")
        clickedMarketName = numOfMarkets[indexPath.row]
        self.grabData(i: numOfMarkets[indexPath.row])
        

        perform(#selector(waitForFireBase), with: nil, afterDelay: 0.2)
    }
    
    
    @objc func waitForFireBase(){
        performSegue(withIdentifier: "detailView", sender: self)
    }
    //Show loading
    func loading(){
        
        let alert = UIAlertController(title: nil, message: "loading Data...", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.green
        
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.color = UIColor.white
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let ref = Database.database().reference().child("users").child(uid).child("list").child(numOfMarkets[indexPath.row])
            numOfMarkets.remove(at: indexPath.row)
            ref.removeValue()
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
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
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailView") {
            // initialize new view controller and cast it as view controller
            let viewController = segue.destination as! DetailViewController
            
            //pass market information
            viewController.marketName = clickedMarketName
            viewController.productArray = products
            self.products.removeAll()
            //self.dismiss(animated: false, completion: nil)
        }
    }
    
}
