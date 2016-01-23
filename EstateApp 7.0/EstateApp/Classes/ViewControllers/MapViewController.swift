//
//  MapViewController.swift
//  EstateApp
//
//  Created by JayD on 03/07/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit

class MapViewController: BaseViewController {

    var settingsView = SettingControlView.loadWithNib() as! SettingControlView;
    @IBOutlet weak var constraintTopSeachView: NSLayoutConstraint!
    @IBOutlet weak var settingContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSettingControlView();
    }
    
    func addSettingControlView()
    {
        self.constraintTopSeachView.constant = -320 + (20+20+42);

        self.settingContainer .addSubview(settingsView)
        settingsView.btnSearch.addTarget(self, action: "btnSeachPressed", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func btnSeachPressed(){
        
        if settingsView.isOpen
        {
            self.constraintTopSeachView.constant = -320 + (20+20+42);
        }
        else
        {
            self.constraintTopSeachView.constant = 0;
        }
        
//
//        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
//            
//            self.settingContainer.layoutIfNeeded()
//            
//            }) { (completed) -> Void in
//                
//        };
        
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 20.0, options:  UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.settingContainer.layoutIfNeeded()
            
            }) { (completed) -> Void in
                
        };
        
        settingsView.isOpen = !settingsView.isOpen;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
