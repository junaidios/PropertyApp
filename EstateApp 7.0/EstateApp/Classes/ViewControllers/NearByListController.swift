//
//  NearByListController.swift
//  EstateApp
//
//  Created by JayD on 26/05/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit

class NearByListController: BaseViewController , UITableViewDataSource, UITableViewDelegate {
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnMapViewPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell;
        
        return cell;
    }
}
