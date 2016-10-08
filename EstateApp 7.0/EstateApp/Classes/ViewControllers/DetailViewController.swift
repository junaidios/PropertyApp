//
//  DetailViewController.swift
//  EstateApp
//
//  Created by JayD on 27/03/2016.
//  Copyright © 2016 Waqar Ahsan. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var property = Property();
    @IBOutlet weak var lblTileMain: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDemand: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblRooms: UILabel!
    @IBOutlet weak var lblBaths: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var mapView: JSMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblDistance.text = "N/A";

        LocationService.getPropertyDurationsFromCurrentLocation([property], success: { (data) in
            
            self.lblDistance.text = self.property.distance + ", " + self.property.duration + " away";
            self.mapView.addNewPinsFromList([self.property]);
            let propertyPosition = CLLocationCoordinate2D(latitude: Double(self.property.latitude!)!, longitude: Double(self.property.longitude!)!);

            let userPosition = self.mapView.addUserPin();

            self.mapView.showRouteForPoints(userPosition, point2: propertyPosition);
        
            self.mapView.showAnnotations(self.mapView.annotations, animated: true);
            
            }, failure: { (error) in
                
        })
        
        lblTileMain.text = property.titleMsg;
        
        lblTitle.text = property.titleMsg;
        lblSize.text = property.size;
        lblType.text = property.type;
        lblDemand.text =  property.demand!.getCurrencyFormat();
        lblCondition.text = property.condition;
        lblCity.text = property.city;
        lblCountry.text = property.country;
        lblRooms.text = property.numOfRoom;
        lblBaths.text = property.numOfBath;
        lblDetail.text = property.detail;
        lblNote.text = property.specialMsg;
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnGetDirectionsPressed(sender: AnyObject) {
        
        
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            
            let lat = property.latitude! as String;
            let lng = property.longitude! as String;
            
            let urlString = "comgooglemaps://?saddr=&daddr=" + lat + "," + lng + "&directionsmode=driving";
            
            UIApplication.sharedApplication().openURL(NSURL(string:urlString)!)
            
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

    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return property.photos.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let url = property.photos[indexPath.row] as! String;
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)  ;
        
        let imgView = cell.viewWithTag(100) as! AsyncImageView;
        
        imgView.setURL(NSURL(string: url), placeholderImage: UIImage(named: "imagePP"))
        
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
