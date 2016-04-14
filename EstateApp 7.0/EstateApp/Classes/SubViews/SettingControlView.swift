//
//  SettingControlView.swift
//  EstateApp
//
//  Created by JayD on 04/07/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit
import MapKit




class SettingControlView: BaseViewController, UITextFieldDelegate
{
    
    
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    
    @IBOutlet weak var lblRooms: UILabel!
    @IBOutlet weak var lblBaths: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblRadius: UILabel!
    
    @IBOutlet weak var txtFieldLocation: UITextField!

    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var sliderRooms: UISlider!
    @IBOutlet weak var sliderBaths: UISlider!
    @IBOutlet weak var sliderPrice: UISlider!
    @IBOutlet weak var sliderRadius: UISlider!
    
    @IBOutlet weak var switchBtnLocation: UISwitch!
    @IBOutlet weak var priceSliderContainer: UIView!
    

    let priceRangeSlider = RangeSlider(frame: CGRectZero)
    
    
    func priceRangeSliderValueChanged(rangeSlider: RangeSlider){
        
        
        let minRange = Double(rangeSlider.lowerValue/1000) * 1000;
        let maxRange = Double(rangeSlider.upperValue/1000) * 1000;
        
        lblPrice.text = minRange.getCurrencyFormat() + " - " + maxRange.getCurrencyFormat();
        
        print("Range slider value changed: (\(rangeSlider.lowerValue) \(rangeSlider.upperValue))")
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
            self.loadUserLocation();
        }
    }
    
    
    @IBAction func btnSavePressed(sender: AnyObject) {
     
        let setting = Settings.loadSettings();
        
        setting.latitude = lblLatitude.text!;
        setting.longitude = lblLongitude.text!;
        setting.rooms = lblRooms.text!;
        setting.baths = lblBaths.text!;
        setting.radius = String(Int(sliderRadius.value));
        setting.minPrice =  String(Int(priceRangeSlider.lowerValue));
        setting.maxPrice =  String(Int(priceRangeSlider.upperValue));
        setting.locationName = txtFieldLocation.text!;
        setting.isCustomLocation = switchBtnLocation.on;
        
        setting.saveSettings();
        
        self.toggleLeft();
         
        
    }

    func setupPriceRangeSlider()
    {
        priceSliderContainer.addSubview(self.priceRangeSlider)

        self.priceRangeSlider.addTarget(self, action: "priceRangeSliderValueChanged:", forControlEvents: .ValueChanged)
        self.priceRangeSlider.trackHeighlightTintColor = UIColor(hex: "#52B1E1");
        self.priceRangeSlider.curvaceousness = 1.0
        self.priceRangeSlider.frame = priceSliderContainer.bounds
    }
    
    func loadUserLocation(){
        
        if (switchBtnLocation.on == false)
        {
            LocationManager.sharedInstance.getUserCurrentLocation(GPSDataType.GPSDataTypeLatLong, completion: { (data) -> () in
                
                let location = data as! CLLocation;
                self.lblLatitude.text = String(location.coordinate.latitude.roundToPlaces(6));
                self.lblLongitude.text = String(location.coordinate.longitude.roundToPlaces(6));
                
                LocationManager.sharedInstance.getAddressFromLocation(location, completion: { (data) -> () in
                    
                    self.txtFieldLocation.text = data as? String;
                });
                
            })
        }
    }
    
    @IBAction func sliderPriceValueChanged(slider: UISlider) {
        
        let value = Int(slider.value)
        lblPrice.text = String(value);
    }
    
    @IBAction func sliderRoomsValueChanged(slider: UISlider) {
        
        let value = Int(slider.value)
        if value == 0 {
            lblRooms.text = "Any";
        }
        else {
            lblRooms.text = String(value);
        }
    }
    
    @IBAction func sliderRadiusChangeValue(slider: UISlider) {
        
        let value = Int(slider.value)
        lblRadius.text = String(value) + "km";
    }
    
    @IBAction func sliderBathValueChanged(slider: UISlider) {
        
        let value = Int(slider.value)
        if value == 0 {
            lblBaths.text = "Any";
        }
        else {
            lblBaths.text = String(value);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadUserLocation();
        self.setupPriceRangeSlider();
        self.txtFieldLocation.delegate = self;

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        let setting = Settings.loadSettings();
        lblRooms.text = setting.rooms;
        lblBaths.text = setting.baths;
        lblRadius.text = setting.radius  + "km";
        lblPrice.text = Double(setting.minPrice)!.getCurrencyFormat() + " - " + Double(setting.maxPrice)!.getCurrencyFormat();
        
        if lblRooms.text == "Any"{
            sliderRooms.value = 0
        }
        else{
            sliderRooms.value = Float(lblRooms.text!)!;
        }
        
        if lblBaths.text == "Any"{
            sliderBaths.value = 0
        }
        else{
            sliderBaths.value = Float(lblBaths.text!)!;
        }
        
        sliderRadius.value = Float(setting.radius)!;

        switchBtnLocation.on = setting.isCustomLocation;
        
        if switchBtnLocation.on {
            lblLatitude.text = setting.latitude;
            lblLongitude.text = setting.longitude;
            txtFieldLocation.text = setting.locationName;
            txtFieldLocation.enabled = true;
        }
        priceRangeSlider.lowerValue = Double(setting.minPrice)!;
        priceRangeSlider.upperValue = Double(setting.maxPrice)!;
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {


        textField.resignFirstResponder();
        
        LocationManager.sharedInstance.getLocationFromAddress(textField.text!) { (data) -> () in
            
            let location = data as! CLLocation;
            self.lblLatitude.text = String(location.coordinate.latitude.roundToPlaces(6));
            self.lblLongitude.text = String(location.coordinate.longitude.roundToPlaces(6));
        }
        
        return true;
    }
}
