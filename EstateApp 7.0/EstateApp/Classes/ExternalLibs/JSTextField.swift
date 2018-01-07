//
//  JSTextField.swift
//  Erinnerungsorte
//
//  Created by JayD on 06/06/2016.
//  Copyright © 2016 Administrator. All rights reserved.
//


import UIKit

class JSTextField: UITextField, UITextFieldDelegate {
    
    
    func colorUpdate() {
        
        if self.tag == 101 { // Types
            
            self.backgroundColor = UIColor.red;
            
            let row = 10 - Int(self.text!)!
            
            if row > 3 && row <= 7 {
                self.backgroundColor = UIColor.orange;
            }
            if row > 7 && row <= 10 {
                
                self.backgroundColor = UIColor.init(red: 0.36, green: 0.64, blue: 0.35, alpha: 1.0);
            }
        }
        
    }
    
    private var optionTextLabel: UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        
        if self.tag == 101 { // Types
            
            self.round();
            self.borderUIColor(color: UIColor.black)
            
            var list: [String] = [];
            
            for i in 0...10 {
                
                list.append("\(10-i)");
            }
            
            self.inputView = KeyboardListView.loadWithNib(self, options: list, color: true);
            
        }
        else if self.tag == 100 { // Countries
            
            let list = ["House", "Plot", "Shop", "Farm"];
            
            self.inputView = KeyboardListView.loadWithNib(self, options: list, color: false);
            
        }
        else if self.tag == 102 { // Countries
            
            let list = ["New", "Old", "Good", "Nice"];
            
            self.inputView = KeyboardListView.loadWithNib(self, options: list, color: false);
            
        }
        
        self.addTarget(self, action: #selector(self.textFieldPlaceholderUpdate), for: .editingChanged)
        self.textFieldPlaceholderUpdate();
        self.background = #imageLiteral(resourceName: "tfBg");
    }
    
    var tfName: UITextField!
    
    var padding = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 16);
    var zeroPadding = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0);
    
    override var text: String? {
        didSet {
            self.textFieldPlaceholderUpdate();
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        if tag == 101 {
            
            return UIEdgeInsetsInsetRect(bounds, padding)
        }
        
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
        if tag == 101 {
            
            return UIEdgeInsetsInsetRect(bounds, padding)
        }
        
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        if tag == 101 {
            
            return UIEdgeInsetsInsetRect(bounds, padding)
        }
        
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    
    override func draw(_ rect: CGRect) {
        
        if optionTextLabel == nil, tag != 101 {
            
            optionTextLabel = UILabel()
            optionTextLabel?.frame = CGRect(x: padding.left, y: 6, width: self.bounds.width - (padding.left + padding.left), height: 16)
            optionTextLabel?.font = self.font?.withSize(10);
            optionTextLabel?.textColor = self.textColor
            optionTextLabel?.tag = 999
            optionTextLabel?.textColor = UIColor.lightGray
            optionTextLabel?.textAlignment = .left
            optionTextLabel?.text = "";
            self.addSubview(optionTextLabel!)
            //            self.sendSubview(toBack: optionTextLabel!)
        }
        
        super.draw(rect)
    }
    
    @objc func textFieldPlaceholderUpdate() {
        
        if self.text!.length > 0 {
            
            padding = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 16);
            zeroPadding = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0);
            optionTextLabel?.text = self.placeholder
        }
        else {
            
            padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16);
            zeroPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
            optionTextLabel?.text = "";
        }
        
        self.layoutIfNeeded();
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        if tag != 101 {
            
            self.textFieldPlaceholderUpdate();
        }
    }
}

class JSPriortyTextField: UITextField, UITextFieldDelegate {

    func colorUpdate() {
        
        if self.tag == 101 { // Types
            
            self.backgroundColor = UIColor.red;
            
            let row = 10 - Int(self.text!)!
            
            if row > 3 && row <= 7 {
                self.backgroundColor = UIColor.orange;
            }
            if row > 7 && row <= 10 {
                
                self.backgroundColor = UIColor.init(red: 0.36, green: 0.64, blue: 0.35, alpha: 1.0);
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        if self.tag == 101 { // Types
            
            self.round();
            self.borderUIColor(color: UIColor.black)
            
            var list: [String] = [];
            
            for i in 0...10 {
                
                list.append("\(10-i)");
            }
            
            self.inputView = KeyboardListView.loadWithNib(self, options: list, color: true);
            
        }
    }
}
