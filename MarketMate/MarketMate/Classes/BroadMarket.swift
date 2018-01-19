//
//  BroadMarket.swift
//  MarketMate
//
//  Created by Sean Lohman on 1/14/18.
//  Copyright © 2018 Sean Lohman. All rights reserved.
//

import Foundation

//Broad Market Class to Store the Basic Market Details from the First parse
class BroadMarket {
    
    let id: String
    let marketName: String
    
    //Creating an initializer for the market class
    init(id: String, marketName: String) {
        self.id = id
        self.marketName = marketName
        
    }
}
