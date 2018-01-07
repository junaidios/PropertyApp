//
//  SettingsViewController.swift
//  EstateApp
//
//  Created by JayD on 26/05/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

class AddPropertyViewController: BaseViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, JSMapViewDelegate {
    

    var imageNumber = 100;

    var latLong = CLLocationCoordinate2DMake(0, 0);
    
    @IBOutlet weak var lblRooms: UILabel!
    @IBOutlet weak var lblBath: UILabel!
    @IBOutlet weak var lblKitchen: UILabel!
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfSize: UITextField!
    @IBOutlet weak var tfType: UITextField!
    @IBOutlet weak var tfDemand: UITextField!
    @IBOutlet weak var tfCondition: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var tfCountry: UITextField!
    @IBOutlet weak var tfDescription: JSPlaceHolderTextView!
    @IBOutlet weak var tfSpecialNote: JSPlaceHolderTextView!
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var imgView3: UIImageView!
    @IBOutlet weak var tfOwnerName: UITextField!
    @IBOutlet weak var tfOwnerNumber: UITextField!
    @IBOutlet weak var tfOwnerAddress: UITextField!
    @IBOutlet weak var tfOwnerEmail: UITextField!
    
    @IBOutlet weak var mapView: JSMapView!
    let picker = UIImagePickerController();
    
    @IBAction func btnAddImagePressed(_ button: UIButton) {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { UIAlertAction in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default) { UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { UIAlertAction in
            
        }
        
        // Add the actions
        picker.delegate = self;
        picker.allowsEditing = true;
        imageNumber = button.tag;
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){

            picker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(picker, animated: true, completion: nil)
        }
        else {
            JSAlertView.show("You don't have camera");
        }
    }
    
    func openGallary(){
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func mapViewSelectedLocation(_ coordinate: CLLocationCoordinate2D, city: String, country: String) {
        
        tfCity.text = city;
        tfCity.delegate = self;
        tfCountry.text = country;
        latLong = coordinate;
    }
    
    func mapViewAnnonationTap(_ property: Property) {
        
    }
    
    //MARK:UIImagePickerControllerDelegate
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        picker .dismiss(animated: true, completion: nil)
        
        let imgTemp = info[UIImagePickerControllerEditedImage] as? UIImage
        let image = imgTemp?.resizeImage(targetSize: CGSize(width: 200, height: 200));
        if imageNumber == 100 {
            imgView1.image = image
        }
        else if imageNumber == 101 {
            imgView2.image = image;
        }
        else if imageNumber == 102 {
            imgView3.image = image;
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        print("picker cancel.")
        picker.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self;   //the required delegate to get a photo back to the app.
        mapView.delegated = self;
        tfCity.delegate = self;
        tfCountry.delegate = self;
        mapView.cornerRadius(5.0);
        tfDescription.placeholder = "Description";
        tfSpecialNote.placeholder = "Notes";
        
        imgView1.cornerRadius(4.0);
        imgView2.cornerRadius(4.0);
        imgView3.cornerRadius(4.0);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == tfCity || textField == tfCountry {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
        }
        return false;
    }
    

    @IBAction func sliderRoomsChangeValue(_ slider: UISlider) {
        
        let value = Int(slider.value)
        lblRooms.text = String(value);
    }
    
    @IBAction func sliderBathChangeValue(_ slider: UISlider) {
        
        let value = Int(slider.value)
        lblBath.text = String(value);
    }
    
    @IBAction func sliderKitchenChangeValue(_ slider: UISlider) {
        
        let value = Int(slider.value)
        lblKitchen.text = String(value);
    }
    
    @IBAction func btnHideScreenPressed(_ sender: AnyObject) {
    
        self.dismiss(animated: true) { () -> Void in };
    }
    
    @IBAction func btnSavePressed(_ sender: UIButton) {
        
        if tfTitle.text!.length < 3 {
            
            JSAlertView.show("Please enter title"); return;
        }
        if tfSize.text!.length <= 1 {
            
            JSAlertView.show("Please enter property Size"); return;
        }
        if tfDemand.text!.length < 2 {
            
            JSAlertView.show("Please enter amount you demand."); return;
        }
        
        let latitude = String(latLong.latitude);
        let longitude = String(latLong.longitude);
        
        SwiftSpinner.show("Loading...")

        EstateService.savePropertyWhere (
            title: tfTitle.text!, size: tfSize.text!, type: tfType.text!, demand: tfDemand.text!,
            condition: tfCondition.text!, latitude: latitude, longitude: longitude, city: tfCity.text!,
            country: tfCountry.text!, description: tfDescription.text!, specialNote: tfSpecialNote.text!,
            rooms: lblRooms.text!, baths: lblBath.text!, kitchen: lblKitchen.text!, ownerName: tfOwnerName.text!,
            ownerNumber: tfOwnerNumber.text!, ownerAddress: tfOwnerAddress.text!, ownerEmail: tfOwnerEmail.text!,
            img1: imgView1.image, img2: imgView2.image, img3: imgView3.image, success: { (data) -> Void in

                SwiftSpinner.hide();
                self.dismiss(animated: true) { () -> Void in
                    
                }
            })
            { (error) -> Void in
                
                SwiftSpinner.hide();

                JSAlertView.show((error?.localizedDescription)!);

        }
    }
}

extension AddPropertyViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.tfCity.text = place.formattedAddress;
        self.mapView.addPinOnGetCityAndCountry(place.coordinate);
//        place.coordinate
        
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

