//
//  SettingControlView.swift
//  EstateApp
//
//  Created by JayD on 04/07/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces
import WARangeSlider

class SettingControlView: BaseViewController, UITextFieldDelegate
{
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    
    @IBOutlet weak var lblRooms: UILabel!
    @IBOutlet weak var lblBaths: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblRadius: UILabel!
    
    @IBOutlet weak var txtFieldLocation: JSTextField!

    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var sliderRooms: UISlider!
    @IBOutlet weak var sliderBaths: UISlider!
    @IBOutlet weak var sliderPrice: UISlider!
    @IBOutlet weak var sliderRadius: UISlider!
    
    @IBOutlet weak var radiusPriority: JSTextField!
    @IBOutlet weak var roomsPriority: JSTextField!
    @IBOutlet weak var bathsPriority: JSTextField!
    @IBOutlet weak var pricePriority: JSTextField!
    
    @IBOutlet weak var switchBtnLocation: UISwitch!
    @IBOutlet weak var priceSliderContainer: RangeSlider!
    

    var isOpen = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
        let popoverViewController = segue.destination
        popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        
            self.definesPresentationContext = true; //self is presenting view controller
            
            popoverViewController.popoverPresentationController?.backgroundColor = UIColor(white: 1.0, alpha: 0.85);
        popoverViewController.popoverPresentationController?.permittedArrowDirections = .any
            if #available(iOS 9.0, *) {
                popoverViewController.popoverPresentationController?.canOverlapSourceViewRect = true
                
            } else {
                // Fallback on earlier versions
            }
            
        popoverViewController.popoverPresentationController?.permittedArrowDirections = .any
            popoverViewController.preferredContentSize = CGSize(width: 200, height: 60)
            
           
//        }
    }

    @IBAction func btnToSwitchOnOffCustomLocation(_ switchBtn: UISwitch) {
        
        if switchBtn.isOn
        {
            txtFieldLocation.isEnabled = true;
        }
        else
        {
            txtFieldLocation.isEnabled = false;
            self.loadUserLocation();
        }
    }
    
    
    @IBAction func btnSavePressed(_ sender: AnyObject) {
     
        let setting = Settings.loadSettings();
        
        setting.rooms = lblRooms.text!;
        setting.baths = lblBaths.text!;
        setting.radius = String(Int(sliderRadius.value));
        setting.minPrice =  String(Int(priceSliderContainer.lowerValue));
        setting.maxPrice =  String(Int(priceSliderContainer.upperValue));

        setting.latitude = lblLatitude.text!;
        setting.longitude = lblLongitude.text!;
        setting.locationName = txtFieldLocation.text!;
//        setting.isCustomLocation = switchBtnLocation.isOn;
        
        setting.roomsPriority = roomsPriority.text!;
        setting.bathsPriority = bathsPriority.text!;
        setting.pricePriority = pricePriority.text!;
        setting.radiusPriority = radiusPriority.text!;
        
        setting.saveSettings();
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mapViewPinReloaded"), object: nil)

        self.toggleLeft();
    
        
    }

    func setupPriceRangeSlider()
    {
        self.priceSliderContainer.trackHighlightTintColor = UIColor(hex: "#227F00");
        self.priceSliderContainer.curvaceousness = 1.0
    }
    
    func loadUserLocation(){
        
//        if (switchBtnLocation.isOn == false)
//        {
//            JSLocationManager.sharedInstance.getUserCurrentLocation(.coordinate, completion: { (data) -> () in
//
//                let location = data as! CLLocation;
//                self.lblLatitude.text = "\(location.coordinate.latitude)";
//                self.lblLongitude.text = "\(location.coordinate.longitude)";
//
//                JSLocationManager.sharedInstance.getAddressFromLocation(location, completion: { (data) -> () in
//
//                    self.txtFieldLocation.text = data as? String;
//                });
//
//            })
//        }
    }
    
    @IBAction func sliderPriceValueChanged(_ slider: UISlider) {
        
        let value = Int(slider.value)
        lblPrice.text = String(value);
    }
    
    @IBAction func sliderRoomsValueChanged(_ slider: UISlider) {
        
        let value = Int(slider.value)
        if value == 0 {
            lblRooms.text = "Any";
        }
        else {
            lblRooms.text = String(value);
        }
    }
    
    @IBAction func sliderRadiusChangeValue(_ slider: UISlider) {
        
        let value = Int(slider.value)
        lblRadius.text = String(value) + "km";
    }
    
    @IBAction func sliderBathValueChanged(_ slider: UISlider) {
        
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
        self.txtFieldLocation.isEnabled = true;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        let setting = Settings.loadSettings();
        
        roomsPriority.text = setting.roomsPriority;
        bathsPriority.text = setting.bathsPriority;
        pricePriority.text = setting.pricePriority;
        radiusPriority.text = setting.radiusPriority;
        
        roomsPriority.colorUpdate();
        bathsPriority.colorUpdate();
        pricePriority.colorUpdate();
        radiusPriority.colorUpdate();
        
        lblRooms.text = setting.rooms;
        lblBaths.text = setting.baths;
        lblRadius.text = setting.radius  + "km";
        txtFieldLocation.text = setting.locationName;
        lblLatitude.text = setting.latitude;
        lblLongitude.text = setting.longitude;
        
        let minValue = Int(setting.minPrice) ?? 0;
        let maxValue = Int(setting.maxPrice) ?? 0;

        priceSliderContainer.lowerValue = Double(minValue)
        priceSliderContainer.upperValue = Double(maxValue)
        
        let minRate = "\(minValue * 10000)";
        let maxRate = "\(maxValue * 10000)";
        
        lblPrice.text = minRate.toCurrency + " - " + maxRate.toCurrency
        
        if lblRooms.text == "Any"{
            sliderRooms.value = 0
        }
        else{
            sliderRooms.value = Float(lblRooms.text!)!;
        }
        
        if lblBaths.text == "Any"{
            sliderBaths.value = 0
        }
        else {
            sliderBaths.value = Float(lblBaths.text!)!;
        }
        
        sliderRadius.value = Float(setting.radius)!;

        self.loadUserLocation();
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        if textField == txtFieldLocation {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
        }
        return false;
    }
    
    
    @IBAction func priceRangeUpdated(_ rangeSlider: RangeSlider) {

        let minRate = "\(Int(rangeSlider.lowerValue) * 10000)";
        let maxRate = "\(Int(rangeSlider.upperValue) * 10000)";
        
        lblPrice.text = minRate.toCurrency + " - " + maxRate.toCurrency
        
        print("Range slider value changed: (\(rangeSlider.lowerValue) \(rangeSlider.upperValue))")

    }
}

extension SettingControlView: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let setting = Settings.loadSettings();

        self.txtFieldLocation.text = place.name;
        self.lblLatitude.text = "\(place.coordinate.latitude)";
        self.lblLongitude.text = "\(place.coordinate.longitude)";

        setting.latitude = lblLatitude.text!;
        setting.longitude = lblLongitude.text!;
        setting.locationName = txtFieldLocation.text!;

        setting.saveSettings();
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
