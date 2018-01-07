//
//  DetailViewController.swift
//  EstateApp
//
//  Created by JayD on 27/03/2016.
//  Copyright © 2016 Waqar Ahsan. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: BaseViewController,  UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    var property = Property();
    var titles = [String]();
    var values = [String]();
    
    @IBOutlet weak var lblTileMain: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var mapView: JSMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.estimatedRowHeight = 97;
        tblView.rowHeight = UITableViewAutomaticDimension;

        lblTileMain.text = property.titleMsg;

        LocationService.getPropertyDurationsFromCurrentLocation(locations: [property], success: { (data) in

            if let distanceStr = data as? [(String, Int, String, Int)], distanceStr.count > 0 {
                if let tupple = distanceStr.first {
                    self.lblDistance.text = tupple.0 + ", " + tupple.2 + " away";
                    self.lblDistance.text = "";

                    if tupple.0.length > 0 {
                        self.lblDistance.text = tupple.0;
                    }
                    if tupple.2.length > 0 {
                        if  self.lblDistance.text!.length == 0 {
                            self.lblDistance.text = tupple.2;
                        }
                        else {
                            self.lblDistance.text = self.lblDistance.text! + ", " + tupple.2;
                        }
                    }
                }
            }
            self.mapView.addNewPinsFromList([self.property]);
            let propertyPosition = CLLocationCoordinate2D(latitude: Double(self.property.latitude)!, longitude: Double(self.property.longitude)!);

            let userPosition = self.mapView.addUserPin();

            self.mapView.showRouteForPoints(point1: userPosition, point2: propertyPosition);

            self.mapView.showAnnotations(self.mapView.annotations, animated: true);

            }, failure: { (error) in

        })
        
        titles = ["Title", "Detail", "Size",
                  "Type", "Demand", "Condition",
                  "City", "Country",
                  "Rooms", "Baths",
                  "Note"];
        
        values = [property.titleMsg, property.detail, property.size,
                  property.type, "$" + property.demand.toNumber, property.condition,
                  property.city, property.country,
                  property.numOfRoom, property.numOfBath,
                  property.specialMsg];
        
        self.tblView.reloadData();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnGetDirectionsPressed(_ sender: AnyObject) {
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            
            let lat = property.latitude;
            let lng = property.longitude;
            
            let urlString = "comgooglemaps://?saddr=&daddr=" + lat + "," + lng + "&directionsmode=driving";
            
            UIApplication.shared.openURL(URL(string:urlString)!)
            
        } else {
//            NSLog("Can't use comgooglemaps://");
            
//            var mapItem = MKMapItem()
//
//            mapItem.name = "The way I want to go"
//            
//            //You could also choose: MKLaunchOptionsDirectionsModeWalking
//            var launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
//            
//            mapItem.openInMapsWithLaunchOptions(launchOptions)
        }
    
    }

    // MARK: - UICollectionView

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return property.photos.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let url = property.photos[indexPath.row] ;
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)  ;
        
        let imgView = cell.viewWithTag(100) as! UIImageView;
        
        imgView.setImageWithURI(url);
        imgView.cornerRadius(4);

        return cell;
        
    }
    
    // MARK: - UITableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return values.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let title = titles[indexPath.row];
        let value = values[indexPath.row];
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) ;
        
        let lblTitle = cell.viewWithTag(100) as! UILabel;
        let lblDetail = cell.viewWithTag(101) as! UILabel;
        
        lblTitle.text = title;
        lblDetail.text = value;
        
        return cell;
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
