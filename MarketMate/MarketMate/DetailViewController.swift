//
//  DetailViewController.swift
//  MarketMate
//
//  Created by Sean Lohman on 1/25/18.
//  Copyright © 2018 Sean Lohman. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Member Variables
    var marketName = String()
    var productArray: [String]!
    
    /* IBOUTLETS */
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var name: UILabel!
    
    /* IBACTIONS */

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor.white
        name.text = marketName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
            return productArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath)
        
        cell.textLabel?.text = productArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            var ref = Database.database().reference().child("users").child(uid).child("list").child(marketName)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if !snapshot.exists(){return}
                
                let dict = snapshot.value as! Dictionary<String, String>
                
                for (num, product) in dict{
                    if product == self.productArray[indexPath.row]{
                        ref = ref.child(num)
                        ref.removeValue()
                    }
                }
                self.productArray.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    tableView.reloadData()
                }            })

        }
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
