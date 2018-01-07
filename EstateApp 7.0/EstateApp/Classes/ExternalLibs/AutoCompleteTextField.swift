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
    var data = [Location]();
    var currentTime = 0.0;
    var lastStr = "";
    
    //Set this to override the default color of suggestions popover. The default color is [UIColor colorWithWhite:0.8 alpha:0.9]
    @IBInspectable var popoverBackgroundColor : UIColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    
    //Set this to override the default frame of the suggestions popover that will contain the suggestions pertaining to the search query. The default frame will be of the same width as textfield, of height 200px and be just below the textfield.
    var popoverSize : CGRect?
    
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
        
        if ( self.text!.count > lastStr.count) && (self.isFirstResponder)
        {
            
            currentTime = Date().timeIntervalSince1970;
            
            let deadline = DispatchTime.now() + DispatchTimeInterval.seconds(1)
            
            let mainQueue = DispatchQueue.main
            
            mainQueue.asyncAfter(deadline: deadline) {
                let executeTime = Date().timeIntervalSince1970;
                let difference =  executeTime - self.currentTime;
                print("difference = \(difference)")
                if difference >= 1 {
                    
                    print("loading search")
                    
                    LocationService.loadListOfLocationWhereInput(input: self.lastStr, success: { (locations) in
                        
                        self.data = locations as! [Location];
                        
                        self.provideSuggestions()
                        
                    }, failure: { (error) in
                        
                        print(error?.localizedDescription);
                    })
                }
            }
               
            
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
    
    override func resignFirstResponder() -> Bool {
        

        if let _ = self.tableViewController {
        
            UIView.animate(withDuration: 0.3,
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
        
        return super.resignFirstResponder();
    }
    
    func provideSuggestions(){
        
        if (tableViewController) != nil {
            tableViewController!.tableView.reloadData()
           // self.delegate = self
        }
        else if self.text!.length > 0{
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
            
            UIView.animate(withDuration: 0.3,
                                       animations: ({
                                        self.tableViewController!.tableView.alpha = 1.0
                                       }),
                                       completion:{
                                        (finished : Bool) in
                                        
            })

        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        let count = data.count
        
        if count == 0{
        
            UIView.animate(withDuration: 0.3,
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 30;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "MPGResultsCell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "MPGResultsCell")
 
        }
        
        let location = data[indexPath.row];

        cell!.textLabel!.text =  location.titleMsg;
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 10);

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){

        tableView.deselectRow(at: indexPath as IndexPath, animated: true);
        
        let loc = self.data[indexPath.row];
        
        self.text = loc.titleMsg;

        
        LocationService.loadDetailOfLocationWherePlaceId(placeId: loc.placeId!, success: { (data) -> Void in
            
            if let locObj = data as? Location {
                
                let lat =  Double(locObj.latitude) as! CLLocationDegrees;
                let lng =  Double(locObj.longitude) as! CLLocationDegrees;
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng);
                
                self.mDelegate?.textFieldDidEndEditingWithLocation(location: locObj);
                
                _ = self.resignFirstResponder();
                
                print(coordinate);
            }
//
        }) { (error) -> Void in
            
            print(error!.localizedDescription);
            
            JSAlertView.show(error!.localizedDescription);
            
        }
    }
}
