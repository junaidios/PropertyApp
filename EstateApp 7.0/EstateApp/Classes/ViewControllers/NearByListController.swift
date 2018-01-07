//
//  NearByListController.swift
//  EstateApp
//
//  Created by JayD on 26/05/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit
import MapKit
class NearByListController: BaseViewController , UITableViewDataSource, UITableViewDelegate {
   
    var properties = [Property]();
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var segmentCtrl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tblView.estimatedRowHeight = 97;
        tblView.rowHeight = UITableViewAutomaticDimension;
        
        self.segmentCtrlValueChanged(segmentCtrl);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func segmentCtrlValueChanged(_ sender: UISegmentedControl) {
            
        SwiftSpinner.show("Loading...")
        
        self.properties.removeAll();
        
        if (segmentCtrl.selectedSegmentIndex == 0)
        {
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
                        
                        self.properties = properties.sorted{ ($0.distanceValue == 0 ? Int.max : $0.distanceValue) < ($1.distanceValue == 0 ? Int.max : $1.distanceValue) };
                        self.tblView.reloadData();
                        
                    }, failure: { (error) in
                        
                    })
                }
                
                }) { (error) -> Void in
                   
                    SwiftSpinner.hide();
            };
        }
        else if (segmentCtrl.selectedSegmentIndex == 1)
        {
            EstateService.searchListOfProperties(success: { (propertyList) -> Void in
                
                SwiftSpinner.hide();
                
                if let properties = propertyList as? [Property] {
                    
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

                        self.properties = properties.sorted{ $0.distanceValue < $1.distanceValue };
                        self.tblView.reloadData();
                        
                    }, failure: { (error) in
                        
                    })
                }
                
            }) { (error) -> Void in
                
                SwiftSpinner.hide();
            };
        }
    }
    
    @IBAction func btnMapViewPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return properties.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! PropertyCell;
        
        if properties.count > indexPath.row {
            let property = properties[indexPath.row];
            
            cell.lblDistance.text = "";
            
            if property.duration.length > 0 {
                cell.lblDistance.text = property.duration;
            }
            if property.distance.length > 0 {
                if  cell.lblDistance.text!.length == 0 {
                    cell.lblDistance.text = property.distance;
                }
                else {
                    cell.lblDistance.text = cell.lblDistance.text! + ", " + property.distance;
                }
            }

            cell.lblTitle.text = property.titleMsg;
            cell.lblSize.text = property.size + " ft2";
            cell.lblDemand.text = "$" + property.demand.toNumber;
            cell.imgView.setImageWithURI(property.photo)
            cell.imgView.cornerRadius(4);
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let property = properties[indexPath.row];

        tableView.deselectRow(at: indexPath as IndexPath, animated: true);
        
        self.performSegue(withIdentifier: "detail", sender: property);
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detail" {
        
            let destination = segue.destination as! DetailViewController;
            destination.property = sender as! Property;
        
        }
    }
}
