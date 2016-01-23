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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EstateService.listOfProperties({ (propertyList) -> Void in
            
            self.properties.addObjectsFromArray(propertyList as! [AnyObject]);
            self.tblView.reloadData();
            
        }) { (error) -> Void in
            
        };
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        cell.lblTitle.text = property.titleMsg;
        cell.lblSize.text = property.size;
        cell.lblDistance.text = property.city;
        cell.lblDemand.text = property.demand;
        cell.imgView.setURL(NSURL(string: property.photo!), placeholderImage: UIImage(named: "imagePP"))
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("detail", sender: nil);
    }
}
