//
//  SettingControlView.swift
//  EstateApp
//
//  Created by JayD on 04/07/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit

class SettingControlView: UIView
{
    
    
    @IBOutlet weak var lblRooms: UILabel!
    @IBOutlet weak var lblBaths: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var txtFieldLocation: UITextField!

    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var sliderRooms: UISlider!
    @IBOutlet weak var sliderBaths: UISlider!
    @IBOutlet weak var sliderPrice: UISlider!
    
    @IBOutlet weak var priceSliderContainer: UIView!
    
    let priceRangeSlider = RangeSlider(frame: CGRectZero)
    
    
    func priceRangeSliderValueChanged(rangeSlider: RangeSlider){
        
        
        let minRange = Int(rangeSlider.lowerValue*20) * 500;
        let maxRange = Int(rangeSlider.upperValue*20) * 500;
        
//        if minRange % 10 == 0 && maxRange % 10 == 0
//        {
            lblPrice.text = String(minRange) + " - " + String(maxRange) ;
//        }
//        print("Range slider value changed: (\(rangeSlider.lowerValue) \(rangeSlider.upperValue))")
    }

    
    var isOpen = false

    @IBAction func btnToSwitchOnOffCustomLocation(switchBtn: UISwitch) {
    
       if switchBtn.on
       {
            txtFieldLocation.enabled = true;
        }
        else
       {
            txtFieldLocation.enabled = false;
        }
        
    }
    
    func updateLocationText(address:String) {
    
        print(address);
        
        txtFieldLocation.text = address;
    }

    func setupPriceRangeSlider()
    {
        priceSliderContainer.addSubview(self.priceRangeSlider)

        self.priceRangeSlider.addTarget(self, action: "priceRangeSliderValueChanged:", forControlEvents: .ValueChanged)
        self.priceRangeSlider.trackHeighlightTintColor = UIColor(red: 232.0/255.0, green: 158.0/255.0, blue: 52.0/255.0, alpha: 1.0);
        self.priceRangeSlider.curvaceousness = 1.0
        self.priceRangeSlider.frame = priceSliderContainer.bounds
    }
    
    func loadUserLocation(){
        
        LocationManager.sharedInstance.getUserCurrentLocation(GPSDataType.GPSDataTypeAddress, completion: { (data) -> () in

            self.txtFieldLocation.text = data as? String;
            
            self.updateLocationText(data as! String);
        })
    }
    
    @IBAction func sliderPriceValueChanged(slider: UISlider) {
        
        let value = Int(slider.value)
        lblPrice.text = String(value);
    }
    
    @IBAction func sliderRoomsValueChanged(slider: UISlider) {
        
        let value = Int(slider.value)
        lblRooms.text = String(value);

    }
    
    @IBAction func sliderBathValueChanged(slider: UISlider) {
        
        let value = Int(slider.value)
        lblBaths.text = String(value);
    }
    
    static func loadWithNib() -> UIView
    {
        var settingView: SettingControlView;
        
        settingView = NSBundle.mainBundle().loadNibNamed("SettingControlView", owner: nil, options: nil).first as! SettingControlView
        
        settingView.loadUserLocation();
        settingView.setupPriceRangeSlider();
        return settingView;
        
    }
}
