//
//  VC_Ext_Menu.swift
//  MarketMate
//
//  Created by Sean Lohman on 1/18/18.
//  Copyright © 2018 Sean Lohman. All rights reserved.
//

import Foundation
import UIKit

extension ViewController{
    
    //Function for HamburgerMenu, setting the Reveal Width, selector and the gesture recognizer for when the button is pressed.
    func sideMenu(){
        
        if revealViewController() != nil {
            
            hamburgerButton.target = revealViewController()
            hamburgerButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
}