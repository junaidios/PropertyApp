//
//  SettingsViewController.swift
//  EstateApp
//
//  Created by JayD on 26/05/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit
import MapKit

class AddPropertyViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, JSMapViewDelegate {
    

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
    @IBOutlet weak var tfDescription: UITextView!
    @IBOutlet weak var tfSpecialNote: UITextView!
    @IBOutlet weak var imgView1: UIImageView!
    @IBOutlet weak var imgView2: UIImageView!
    @IBOutlet weak var imgView3: UIImageView!
    @IBOutlet weak var tfOwnerName: UITextField!
    @IBOutlet weak var tfOwnerNumber: UITextField!
    @IBOutlet weak var tfOwnerAddress: UITextField!
    @IBOutlet weak var tfOwnerEmail: UITextField!
    
    @IBOutlet weak var mapView: JSMapView!
    let picker = UIImagePickerController();
    
    @IBAction func btnAddImagePressed(button: UIButton) {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
        }
        
        // Add the actions
        picker.delegate = self;
        picker.allowsEditing = true;
        imageNumber = button.tag;
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func openCamera(){
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){

            picker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(picker, animated: true, completion: nil)
 
        }
        else
        {
            
            let alert = UIAlertView()
            alert.title = "Warning"
            alert.message = "You don't have camera"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    func openGallary(){
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func mapViewSelectedLocation(coordinate: CLLocationCoordinate2D, city: String, country: String) {
        
        tfCity.text = city;
        tfCountry.text = country;
        latLong = coordinate;
    }
    
    func mapViewAnnonationTap(property: Property) {
        
    }
    
    //MARK:UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        picker .dismissViewControllerAnimated(true, completion: nil)
        
        let imgTemp = info[UIImagePickerControllerEditedImage] as? UIImage
        let image = imgTemp?.resizeImage(CGSizeMake(200, 200));
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
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        print("picker cancel.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self;   //the required delegate to get a photo back to the app.
        mapView.delegated = self;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func sliderRoomsChangeValue(slider: UISlider) {
        
        let value = Int(slider.value)
        lblRooms.text = String(value);
    }
    
    @IBAction func sliderBathChangeValue(slider: UISlider) {
        
        let value = Int(slider.value)
        lblBath.text = String(value);
    }
    
    @IBAction func sliderKitchenChangeValue(slider: UISlider) {
        
        let value = Int(slider.value)
        lblKitchen.text = String(value);
    }
    
    @IBAction func btnHideScreenPressed(sender: AnyObject) {
    
        self.dismissViewControllerAnimated(true) { () -> Void in
        };
    }
    
    @IBAction func btnSavePressed(sender: UIButton) {
        
        if tfTitle.text?.length < 3 {
            
            JSAlertView.show("Please enter title"); return;
        }
        if tfSize.text?.length <= 1 {
            
            JSAlertView.show("Please enter property Size"); return;
        }
        if tfDemand.text?.length < 2 {
            
            JSAlertView.show("Please enter amount you demand."); return;
        }
        
        let latitude = String(latLong.latitude);
        let longitude = String(latLong.longitude);
        
        self.view.showLoading();
        
        EstateService.savePropertyWhere(
            title: tfTitle.text!, size: tfSize.text!, type: tfType.text!, demand: tfDemand.text!,
            condition: tfCondition.text!, latitude: latitude, longitude: longitude, city: tfCity.text!,
            country: tfCountry.text!, description: tfDescription.text, specialNote: tfSpecialNote.text,
            rooms: lblRooms.text!, baths: lblBath.text!, kitchen: lblKitchen.text!, ownerName: tfOwnerName.text!,
            ownerNumber: tfOwnerNumber.text!, ownerAddress: tfOwnerAddress.text!, ownerEmail: tfOwnerEmail.text!,
            img1: imgView1.image, img2: imgView2.image, img3: imgView3.image, success: { (data) -> Void in

                self.view.hideLoading();
                
                self.dismissViewControllerAnimated(true) { () -> Void in
                }
                
            })
            { (error) -> Void in
                
                self.view.hideLoading();

                JSAlertView.show((error?.localizedDescription)!);

        }
        
        
    }
}
