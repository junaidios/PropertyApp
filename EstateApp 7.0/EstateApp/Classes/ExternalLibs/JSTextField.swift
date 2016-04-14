//
//  JSTextField.swift
//  EstateApp
//
//  Created by JayD on 23/03/2016.
//  Copyright © 2016 Waqar Ahsan. All rights reserved.
//

import UIKit

class JSTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        
        if self.tag == 100 {
            
            let list : NSMutableArray = [
//                "Any Type",
//            "--------- Homes ---------",
            "Houses",
            "Flats",
            "Upper Portions",
            "Lower Portions",
            "Farm Houses",
            "Rooms",
            "Penthouse",
//            "--------- Plots ---------",
            "Residential Plots",
            "Commercial Plots",
            "Agricultural Land",
            "Industrial Land",
            "Plot Files",
            "Plot Forms",
//            "--------- Commercial ---------",
            "Offices",
            "Shops",
            "Warehouses",
            "Factories",
            "Buildings",
            "Other"];
            
            self.inputView = KeyboardListView.loadWithNib(self, options: list);
            
        }
        if self.tag == 101 { // Condition
            
            self.inputView = KeyboardListView.loadWithNib(self, options: ["New", "Old", "Historical", "New Used"]);
            
        }
//        if self.tag == 102 { // Rooms
//            
//            self.inputView = KeyboardListView.loadWithNib(self, options: ["Any", "1", "2", "3", "4", "5", "6+", "Studio"]);
//            
//        }
//        if self.tag == 103 {
//            
//            self.inputView = KeyboardListView.loadWithNib(self, options: ["Any", "1", "2", "3", "4", "4+"]);
//            
//        }
    }
    
    
}
