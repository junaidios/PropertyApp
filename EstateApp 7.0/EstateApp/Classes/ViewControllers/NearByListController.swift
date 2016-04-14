//
//  NearByListController.swift
//  EstateApp
//
//  Created by JayD on 26/05/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit

class NearByListController: BaseViewController , UITableViewDataSource, UITableViewDelegate {
   
    var properties = NSMutableArray();
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var segmentCtrl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.segmentCtrlValueChanged(segmentCtrl);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func segmentCtrlValueChanged(sender: UISegmentedControl) {
        
        self.view.showLoading();
        
        self.properties.removeAllObjects();
        
        if (segmentCtrl.selectedSegmentIndex == 0)
        {
            EstateService.listOfProperties({ (propertyList) -> Void in
                
                self.view.hideLoading();
                
                self.properties.addObjectsFromArray(propertyList as! [AnyObject]);
                self.tblView.reloadData();
                
                }) { (error) -> Void in
                   
                    self.view.hideLoading();

            };
        }
        else if (segmentCtrl.selectedSegmentIndex == 1)
        {
            EstateService.searchListOfProperties({ (propertyList) -> Void in
                
                self.view.hideLoading();

                self.properties.addObjectsFromArray(propertyList as! [AnyObject]);
                self.tblView.reloadData();
                
                }) { (error) -> Void in
                    
                    self.view.hideLoading();

            };
        }
    }
    
    @IBAction func btnMapViewPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return properties.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PropertyCell;
        
        let property = properties.objectAtIndex(indexPath.row) as! Property;
        
        var distanceMain = "0";
        
        if let distance = property.distance {
            
            let distanceStr = distance as String;
            let distanceINT = Int(Double(distanceStr)!);
            distanceMain = String(distanceINT) + "km";
        }
        
        cell.lblTitle.text = property.titleMsg;
        cell.lblSize.text = property.size! + " ft2";
        cell.lblDistance.text = "Distance: " + distanceMain + ", City: " + property.city!;
        cell.lblDemand.text = property.demand?.getCurrencyFormat();
        cell.imgView.setURL(NSURL(string: property.photo!), placeholderImage: UIImage(named: "imagePP"))
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let property = properties.objectAtIndex(indexPath.row) as! Property;

        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        
        self.performSegueWithIdentifier("detail", sender: property);
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "detail" {
        
            let destination = segue.destinationViewController as! DetailViewController;
            destination.property = sender as! Property;
        
        }
    }
}
