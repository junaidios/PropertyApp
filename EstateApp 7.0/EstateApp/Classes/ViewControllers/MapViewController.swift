//
//  MapViewController.swift
//  EstateApp
//
//  Created by JayD on 03/07/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController {


    @IBOutlet weak var mapView: JSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        reloadData();
    }

    @IBAction func btnReloadedPressed(sender: AnyObject) {
        
        reloadData();
    }
    
    
    func reloadData() {
    
        LocationManager.sharedInstance.getUserCurrentLocation(GPSDataType.GPSDataTypeLatLong) { (data) -> () in
            
            let location = data as! CLLocation;
            let user_lat = String(location.coordinate.latitude.roundToPlaces(6));
            let user_lng = String(location.coordinate.longitude.roundToPlaces(6));
            let lat = String(self.mapView.centerCoordinate.latitude.roundToPlaces(6));
            let lng = String(self.mapView.centerCoordinate.longitude.roundToPlaces(6));
            let radius = String(self.mapView.getRadius());
            
            self.mapView.setCenterCoordinate(location.coordinate, animated: true);
            
            EstateService.listOfPropertiesForMaps(lat, longitude: lng, ulatitude: user_lat, ulongitude: user_lng, radius: radius, success: { (propertyList) -> Void in
                
                let properties = propertyList as! [Property];
                
                self.mapView.addNewPinsFromList(properties);
                
                self.mapView.showAnnotations(self.mapView.annotations, animated: true);
                
                },
                failure: { (error) -> Void in
                    
                    JSAlertView.show((error?.localizedDescription)!);
            })
        };
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
