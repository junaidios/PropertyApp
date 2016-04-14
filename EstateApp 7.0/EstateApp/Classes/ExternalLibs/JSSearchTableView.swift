//
//  JSSearchController.swift
//  Velodrome
//
//  Created by JayD on 10/02/2016.
//  Copyright © 2016 Junaid iOS. All rights reserved.
//

import UIKit
import MapKit


protocol JSSearchTableViewDelegate: class {
    
    /// Media Launched successfully on the cast device
    func SearchTableViewDidSelectLocation(coordinate: CLLocationCoordinate2D)
}

extension UISearchController {

    override public func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent;
    }
}

class JSSearchTableView: UITableView, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    
    var searchController = UISearchController(searchResultsController: nil)
    var listOfLocations = NSArray();
    weak var delegated: JSSearchTableViewDelegate?

    // MARK: - View Setup
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
      
        
//        self.searchController = UISearchController(searchResultsController: nil)
        // etc. setup tblSearchController
        if #available(iOS 9.0, *) {
            self.searchController.loadViewIfNeeded()
        } else {
            // Fallback on earlier versions
        }    // iOS 9
        
//        searchController.dimsBackgroundDuringPresentation = false
        self.tableHeaderView = searchController.searchBar
        self.delegate = self;
        self.dataSource = self;
        searchController.searchBar.layer.borderWidth = 1.0;
        searchController.searchBar.layer.borderColor = UIColor(red: 0.42, green: 0.81, blue: 0.81, alpha: 1.0).CGColor;
        searchController.searchBar.tintColor = UIColor.whiteColor();
        searchController.searchBar.barTintColor = UIColor(red: 0.42, green: 0.81, blue: 0.81, alpha: 1.0);
        searchController.dimsBackgroundDuringPresentation = false;
        searchController.searchBar.delegate = self;
//        self.setHeight(44.0);
        self.scrollEnabled = false;
        
    }
    
    deinit{
        if let superView = searchController.view.superview
        {
            superView.removeFromSuperview()
        }
    }
    
    func setHeight(height:CGFloat){
    
        let frame = self.frame;
        self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: height);
    }
    
    // MARK: - Table View
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.listOfLocations.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
//        let loc = self.listOfLocations[indexPath.row] as! Location;
        
//        cell.textLabel?.text = loc.titleMsg;
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        searchController.searchBar.resignFirstResponder();
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        
//        let loc = self.listOfLocations[indexPath.row] as! Location;
//        
//        LocationService.loadDetailOfLocationWherePlaceId(loc.placeId!, success: { (data) -> Void in
//            
//            let locObj = data as! Location;
//
//            let lat =  Double(locObj.latitude)! as CLLocationDegrees;
//            let lng =  Double(locObj.longitude)! as CLLocationDegrees;
//            
//            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng);
//            
//            self.delegated?.SearchTableViewDidSelectLocation(coordinate);
//            print(coordinate);
//                    
//            self.setHeight(44.0);
//            self.scrollEnabled = false;
//            
//            }) { (error) -> Void in
//                
//                print(error!.localizedDescription);
//        }
    }
    
    
    func filterContentForSearchText(searchText: String) {
        
//        LocationService.loadListOfLocationWhereInput(searchText, success: { (data) -> Void in
//            
//            self.listOfLocations = NSArray(array: data as! [AnyObject]);
//            
//            self.reloadData();
//            
//            self.setHeight(self.frame.size.height+44);
//            
//            self.scrollEnabled = true;
//            
//            }) { (error) -> Void in
//                
//                print(error!.localizedDescription);
//                
//        }
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterContentForSearchText(searchBar.text!);
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        self.setHeight(44.0);
        self.scrollEnabled = false;
        //self.view.frame.size.height;
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
