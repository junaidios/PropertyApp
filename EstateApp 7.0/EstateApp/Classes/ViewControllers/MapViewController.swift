//
//  MapViewController.swift
//  EstateApp
//
//  Created by JayD on 03/07/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit
import MapKit
import SlideMenuControllerSwift

class MapViewController: BaseViewController, JSMapViewDelegate {


    @IBOutlet weak var mapView: JSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.setNavigationBarItem()
        self.mapView.delegated = self;

        reloadData();

        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadData),
            name: NSNotification.Name(rawValue: "mapViewPinReloaded"),
            object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
    }
    
    
    @IBAction func btnOpenMenu(_ sender: Any) {
        
        self.slideMenuController()?.openLeft();
    }
    

    @IBAction func btnReloadPressed(_ sender: Any) {
        reloadData();
    }
    
    
    @objc func reloadData() {
      
        let setting = Settings.loadSettings();
        
//        let user_lat = setting.latitude;
//        let user_lng = setting.longitude;
//        let radius = setting.radius;
//
//        EstateService.searchListOfProperties( success: { (propertyList) -> Void in
//
//            var properties = propertyList as! [Property];
//
//            LocationService.getPropertyDurationsFromCurrentLocation(locations: properties, success: { (data) in
//
//
//                self.mapView.addNewPinsFromList(properties);
//
//                _ = self.mapView.addUserPin();
//
//                self.mapView.showAnnotations(self.mapView.annotations, animated: true);
//
//
//                }, failure: { (error) in
//
//            })
//
//
//            },failure: { (error) -> Void in
//
//            JSAlertView.show((error?.localizedDescription)!);
//        })
        
        EstateService.listOfProperties(success: { (propertyList) -> Void in
            
            SwiftSpinner.hide();
            
            if var properties = propertyList as? [Property] {
                
                LocationService.getPropertyDurationsFromCurrentLocation(locations: properties, success: { (data) in
                    
                    if let list = data as? [(String, Int, String, Int)], list.count > 0 {
                        for i in 0..<list.count {
                            let tupple = list[i];
                            let property = properties[i];
                            property.duration = tupple.0
                            property.durationValue = tupple.1
                            property.distance = tupple.2
                            property.distanceValue = tupple.3
                        }
                    }
                    
                    properties = properties.sorted{ ($0.distanceValue == 0 ? Int.max : $0.distanceValue) < ($1.distanceValue == 0 ? Int.max : $1.distanceValue) };

                    self.mapView.addNewPinsFromList(properties);
                    
                    _ = self.mapView.addUserPin();
                    
                    self.mapView.showAnnotations(self.mapView.annotations, animated: true);
                    

                    
                }, failure: { (error) in
                    
                })
            }
            
        }) { (error) -> Void in
            
            SwiftSpinner.hide();
        };
    
    }
    
    func mapViewAnnonationTap(_ property: Property){
    
        self.performSegue(withIdentifier: "detail", sender: property);
    }
 

    func mapViewSelectedLocation(_ coordinate: CLLocationCoordinate2D, city: String, country: String) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detail" {
            
            let destination = segue.destination as! DetailViewController;
            destination.property = sender as! Property;
            
        }
    }

}
