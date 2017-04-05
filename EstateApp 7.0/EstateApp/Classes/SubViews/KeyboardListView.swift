//
//  CityListView.swift
//  Velodrome
//
//  Created by JayD on 11/02/2016.
//  Copyright © 2016 Junaid iOS. All rights reserved.
//

import UIKit

class KeyboardListView: UIView, UIPickerViewDataSource, UIPickerViewDelegate{

    var listOfOptions : [String] = [];
    var tfTextField : UITextField!
    var color : Bool = false;
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    func loadCityList(){
    
        self.pickerView .reloadAllComponents();
        
        if(self.listOfOptions.count > 0) {
            
            let cityName = self.listOfOptions[0];
            self.tfTextField.text = cityName;
        }
    }
    
    class func loadWithNib(textField: UITextField, options: [String], color : Bool) -> KeyboardListView{
        
        let view: KeyboardListView = NSBundle.mainBundle().loadNibNamed("KeyboardListView",
            owner: self, options: nil)![0] as! KeyboardListView
        
        view.frame = UIScreen.mainScreen().bounds
        
        view.tfTextField = textField;
        
        view.listOfOptions = options;
        
        view.loadCityList();

        view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 216.0);
        
        textField.backgroundColor = UIColor.redColor();
        
        
        view.color = color;
        
        if color {
            
            let row = 10 - Int(textField.text!)!
            
            if row > 3 && row <= 7 {
                textField.backgroundColor = UIColor.orangeColor();
            }
            if row > 7 && row <= 10 {
                
                textField.backgroundColor = UIColor.init(red: 0.36, green: 0.64, blue: 0.35, alpha: 1.0);
            }
 
        }
       
        
        return view;
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
    
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return listOfOptions.count;
    }
    
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let cityName = listOfOptions[row];
        
        var lblTitle = NSAttributedString(string: cityName, attributes: [NSFontAttributeName:UIFont.boldSystemFontOfSize(10),NSForegroundColorAttributeName:UIColor.redColor()]);
        
        if color {
            
            if row > 3 && row <= 7 {
                lblTitle = NSAttributedString(string: cityName, attributes: [NSFontAttributeName:UIFont.boldSystemFontOfSize(10),NSForegroundColorAttributeName:UIColor.orangeColor()])
            }
            if row > 7 && row <= 10 {
                lblTitle = NSAttributedString(string: cityName, attributes: [NSFontAttributeName:UIFont.boldSystemFontOfSize(10),NSForegroundColorAttributeName:UIColor.init(red: 0.36, green: 0.64, blue: 0.35, alpha: 1.0)])
            }
        }
        
        return lblTitle
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let cityName = listOfOptions[row];
        
//        let cityName = cityData["human_city_name"] as! String;
        
        if color {
            
            
            tfTextField.backgroundColor = UIColor.redColor();
            
            if row > 3 && row <= 7 {
                tfTextField.backgroundColor = UIColor.orangeColor();
            }
            if row > 7 && row <= 10 {
                
                tfTextField.backgroundColor = UIColor.init(red: 0.36, green: 0.64, blue: 0.35, alpha: 1.0);
            }
            
        }
        
        tfTextField.text = cityName;
        
    }
    
    @IBAction func btnHidePressed(sender: AnyObject) {
        
        tfTextField.resignFirstResponder();
    }
    

}
