//
//  CalloutViewController.swift
//  MarketMate
//
//  Created by Sean Lohman on 1/19/18.
//  Copyright © 2018 Sean Lohman. All rights reserved.
//

import UIKit

class CalloutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var market: Market! = nil
    var productArray = [String]()

    @IBOutlet weak var marketTitle: UILabel!
    @IBOutlet weak var marketAddress: UILabel!
    @IBOutlet weak var marketHours: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //makes sure everything is loaded when the view DID load
        setup()

        //setting up a gesture recognizer for the address label
        let tapped = UITapGestureRecognizer(target: self, action: Selector(("addressTapped")))
        marketAddress.addGestureRecognizer(tapped)
    }
    
    func addressTapped(sender: UITapGestureRecognizer){
        print("address tapped!")
    }
    
    func setup(){
        //setting up the view
        var schedule: String!
        marketTitle.text = market.title
        for i in [";", "<br>"]{
            schedule = market.schedule.replacingOccurrences(of: i, with: "")
        }
        
        if schedule == "    "{
            schedule = "No Operating Hours currently found for market"
            
        }
        
        let hours = schedule.split{$0 == " "}
        
        marketHours.text = "Operating Hours: \n\n \(hours[0]) \(hours[1]) \(hours[2]) \n \(hours[3]) \(hours[4]) \(hours[5]) \(hours[6])"
        marketAddress.text = market.address
        
        productArray.removeAll()
        divideProducts()
        
        //making the back button up top white
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    func divideProducts(){
        let stringToDivide = market.products
        productArray = stringToDivide.components(separatedBy: ";")
        for product in productArray{
            print(product)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "product", for: indexPath)
        
            cell.textLabel?.text = productArray[indexPath.row]

        return cell
    }
}
