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
        
        reloadData();
    }

    @IBAction func btnReloadedPressed(sender: AnyObject) {
        
        reloadData();
    }
    
    
    func reloadData() {
      
        let setting = Settings.loadSettings();
        
        let user_lat = setting.latitude;
        let user_lng = setting.longitude;
        let radius = setting.radius;
        
        
        EstateService.listOfPropertiesForMaps(user_lat, longitude: user_lng, ulatitude: user_lat, ulongitude: user_lng, radius: radius, success: { (propertyList) -> Void in
            
            let properties = propertyList as! [Property];
            
            self.mapView.addNewPinsFromList(properties);
            
            self.mapView.showAnnotations(self.mapView.annotations, animated: true);
            
            },
              
        failure: { (error) -> Void in
                                                
                                                JSAlertView.show((error?.localizedDescription)!);
        })
        
    
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
