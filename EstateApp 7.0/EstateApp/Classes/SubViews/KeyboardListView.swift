//
//  CityListView.swift
//  Velodrome
//
//  Created by JayD on 11/02/2016.
//  Copyright © 2016 Junaid iOS. All rights reserved.
//

import UIKit

class KeyboardListView: UIView, UIPickerViewDataSource, UIPickerViewDelegate{

    var listOfOptions : NSMutableArray = [];
    var tfTextField : UITextField!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    func loadCityList(){
    
        self.pickerView .reloadAllComponents();
        
        if(self.listOfOptions.count > 0) {
            
            let cityName = self.listOfOptions[0] as! String;
            self.tfTextField.text = cityName;
        }
    }
    
    class func loadWithNib(textField: UITextField, options: NSMutableArray) -> KeyboardListView{
        
        let view: KeyboardListView = NSBundle.mainBundle().loadNibNamed("KeyboardListView",
            owner: self, options: nil)[0] as! KeyboardListView
        
        view.frame = UIScreen.mainScreen().bounds
        
        view.tfTextField = textField;
        
        view.listOfOptions = NSMutableArray(array: options);
        
        view.loadCityList();

        view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: 216.0);
        
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
        
        let cityName = listOfOptions[row] as! String;
        
//        let cityName = cityData["human_city_name"] as! String;
        
        let lblTitle = NSAttributedString(string: cityName, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 10.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        
        return lblTitle
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let cityName = listOfOptions[row] as! String;
        
//        let cityName = cityData["human_city_name"] as! String;
        
        tfTextField.text = cityName;
        
    }
    
    @IBAction func btnHidePressed(sender: AnyObject) {
        
        tfTextField.resignFirstResponder();
    }
    

}
