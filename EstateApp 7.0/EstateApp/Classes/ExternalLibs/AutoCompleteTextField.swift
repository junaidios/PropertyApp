//
//  TafAutoCompleteTextField.swift
//  WellCost
//
//  Created by Tafveez Mehdi on 24/05/2016.
//  Copyright © 2016 Tafveez iOS. All rights reserved.
//



import UIKit
import MapKit

protocol AutoCompleteTextFieldDelegate{
    func textFieldDidEndEditingWithLocation(location: Location)
    
}

class AutoCompleteTextField: UITextField, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    var mDelegate : AutoCompleteTextFieldDelegate?
    var tableViewController : UITableViewController?
    var data = NSMutableArray();
    
    var lastStr = "";
    
    //Set this to override the default color of suggestions popover. The default color is [UIColor colorWithWhite:0.8 alpha:0.9]
    @IBInspectable var popoverBackgroundColor : UIColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    
    //Set this to override the default frame of the suggestions popover that will contain the suggestions pertaining to the search query. The default frame will be of the same width as textfield, of height 200px and be just below the textfield.
    @IBInspectable var popoverSize : CGRect?
    
    //Set this to override the default seperator color for tableView in search results. The default color is light gray.
    @IBInspectable var seperatorColor : UIColor = UIColor(white: 0.95, alpha: 1.0)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
    
    
    
    func reloadDataForAutoComplete() {
        
        self.provideSuggestions();
        self.tableViewController?.tableView.reloadData();
        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        if ( self.text!.characters.count > lastStr.characters.count) && (self.isFirstResponder())
        {
            
            LocationService.loadListOfLocationWhereInput(lastStr, success: { (locations) in
                    
                
                    self.data = locations as! NSMutableArray;
                    
                    self.provideSuggestions()
                    
                }, failure: { (error) in
                        
                        print(error?.localizedDescription);
                })
               
            
        }
        else{
            if let table = self.tableViewController {
                if table.tableView.superview != nil {
                    table.tableView.removeFromSuperview()
                    self.tableViewController = nil
                }
            }
        }
        
        lastStr = self.text!;

    }
    
    override func resignFirstResponder() -> Bool{
        
        if let _ = self.tableViewController {
        
            UIView.animateWithDuration(0.3,
                                       animations: ({
                                        self.tableViewController!.tableView.alpha = 0.0
                                       }),
                                       completion:{
                                        (finished : Bool) in
                                        
                                        if (self.tableViewController != nil) {
                                            
                                            self.tableViewController!.tableView.removeFromSuperview()
                                            self.tableViewController = nil
                                        }
            })
        }

        return super.resignFirstResponder()
    }
    
    func provideSuggestions(){
        
        if (tableViewController) != nil {
            tableViewController!.tableView.reloadData()
           // self.delegate = self
        }
        else if self.text?.length > 0{
            //Add a tap gesture recogniser to dismiss the suggestions view when the user taps outside the suggestions view
            
            self.tableViewController = UITableViewController()
            self.tableViewController!.tableView.delegate = self
            self.tableViewController!.tableView.dataSource = self
            self.tableViewController!.tableView.backgroundColor = self.popoverBackgroundColor
            self.tableViewController!.tableView.separatorColor = self.seperatorColor
            self.tableViewController!.tableView.separatorInset = UIEdgeInsetsMake(-20, 0, 0, 0);
            self.tableViewController?.view.layer.cornerRadius = 5.0;
            self.tableViewController?.view.layer.masksToBounds = true;

            if let frameSize = self.popoverSize{
                self.tableViewController!.tableView.frame = frameSize
            }
            else{
                //PopoverSize frame has not been set. Use default parameters instead.
                var frameForPresentation = self.frame
                frameForPresentation.origin.y += self.frame.size.height
                frameForPresentation.size.height = 150
                self.tableViewController!.tableView.frame = frameForPresentation
            }
            
            self.tableViewController!.tableView.alpha = 0.0

        }
        
        if (tableViewController != nil) {
            
            self.superview!.addSubview(tableViewController!.tableView)
            var frameForPresentation = self.frame
            frameForPresentation.origin.y += self.frame.size.height;
            frameForPresentation.size.height = CGFloat(data.count * 30);
            tableViewController!.tableView.frame = frameForPresentation
            
            UIView.animateWithDuration(0.3,
                                       animations: ({
                                        self.tableViewController!.tableView.alpha = 1.0
                                       }),
                                       completion:{
                                        (finished : Bool) in
                                        
            })

        }
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        let count = data.count
        
        if count == 0{
        
            UIView.animateWithDuration(0.3,
                                       animations: ({
                                        self.tableViewController!.tableView.alpha = 0.0
                                       }),
                                       completion:{
                                        (finished : Bool) in
                                        if let table = self.tableViewController{
                                            table.tableView.removeFromSuperview()
                                            self.tableViewController = nil
                                        }
            })
        }
        return count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return 30;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MPGResultsCell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MPGResultsCell")
 
        }
        
        let location = data[indexPath.row] as! Location;

        cell!.textLabel!.text =  location.titleMsg;
        cell?.textLabel?.font = UIFont.systemFontOfSize(10);

        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){

        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        
        let loc = self.data[indexPath.row] as! Location;
        
        self.text = loc.titleMsg;

        
        LocationService.loadDetailOfLocationWherePlaceId(loc.placeId!, success: { (data) -> Void in
            
            let locObj = data as! Location;
            
            let lat =  Double(locObj.latitude)! as CLLocationDegrees;
            let lng =  Double(locObj.longitude)! as CLLocationDegrees;
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng);
            
            self.mDelegate?.textFieldDidEndEditingWithLocation(locObj);
            
            self.resignFirstResponder();
            
            print(coordinate);
//
        }) { (error) -> Void in
            
            print(error!.localizedDescription);
            
            JSAlertView.show((error?.localizedDescription)!);
            
        }
    }
    
    
    
    
    
    
}
