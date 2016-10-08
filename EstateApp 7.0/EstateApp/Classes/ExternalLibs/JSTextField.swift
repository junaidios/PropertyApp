//
//  JSTextField.swift
//  Erinnerungsorte
//
//  Created by JayD on 06/06/2016.
//  Copyright © 2016 Administrator. All rights reserved.
//


import UIKit

class JSTextField: UITextField, UITextFieldDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        
        if self.tag == 101 { // Types
            
 
            var list: [String] = [];
            
            for i in 0...10 {
            
                list.append("\(10-i)");
            }
            
            self.inputView = KeyboardListView.loadWithNib(self, options: list);
            
        }
        if self.tag == 102 { // Countries
            
//            let list = NSMutableArray(array: EODatabase.instance.getCountries());
            
//            self.inputView = KeyboardListView.loadWithNib(self,  title:"Select Country:", options: list);
            
        }
    }
    
    func colorUpdate() {
        
        
        self.backgroundColor = UIColor.redColor();
        
        let row = 10 - Int(self.text!)!
        
        if row > 3 && row <= 7 {
            self.backgroundColor = UIColor.orangeColor();
        }
        if row > 7 && row <= 10 {
            
            self.backgroundColor = UIColor.init(red: 0.36, green: 0.64, blue: 0.35, alpha: 1.0);
        }
    }
    
    
}
