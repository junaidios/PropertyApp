//
//  MapViewController.swift
//  EstateApp
//
//  Created by JayD on 03/07/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController, JSMapViewDelegate {


    @IBOutlet weak var mapView: JSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarItem()
        self.mapView.delegated = self;

        reloadData();

        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(reloadData),
            name: "mapViewPinReloaded",
            object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
    }

    @IBAction func btnReloadedPressed(sender: AnyObject) {
        
        reloadData();
    }
    
    
    func reloadData() {
      
        let setting = Settings.loadSettings();
        
//        let user_lat = setting.latitude;
//        let user_lng = setting.longitude;
//        let radius = setting.radius;
        
        
        EstateService.searchListOfProperties( { (propertyList) -> Void in
            
            let properties = propertyList as! [Property];
            
            LocationService.getPropertyDurationsFromCurrentLocation(properties, success: { (data) in
                
                
                self.mapView.addNewPinsFromList(properties);
                
                self.mapView.addUserPin();
                
                self.mapView.showAnnotations(self.mapView.annotations, animated: true);
                
                
                }, failure: { (error) in
                    
            })

          
            
            },
              
        failure: { (error) -> Void in
            
            JSAlertView.show((error?.localizedDescription)!);
        })
        
    
    }
    
    func mapViewAnnonationTap(property: Property){
    
        self.performSegueWithIdentifier("detail", sender: property);

    }
 

    func mapViewSelectedLocation(coordinate: CLLocationCoordinate2D, city: String, country: String) {
        
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "detail" {
            
            let destination = segue.destinationViewController as! DetailViewController;
            destination.property = sender as! Property;
            
        }
    }

}
