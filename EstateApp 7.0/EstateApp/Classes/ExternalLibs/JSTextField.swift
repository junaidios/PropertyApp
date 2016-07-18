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
            
 
            let list = NSMutableArray(array: EODatabase.instance.getTypes());
            
            self.inputView = KeyboardListView.loadWithNib(self, title:"Select Category:", options: list);
            
        }
        if self.tag == 102 { // Countries
            
            let list = NSMutableArray(array: EODatabase.instance.getCountries());
            
            self.inputView = KeyboardListView.loadWithNib(self,  title:"Select Country:", options: list);
            
        }
    }
    
    
    
}
