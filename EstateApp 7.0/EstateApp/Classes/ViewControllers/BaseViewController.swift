//
//  BaseViewController.swift
//  EstateApp
//
//  Created by JayD on 26/05/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true);
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showAlertMessage(message:String){
    
        UIAlertView(title: "Property App!",
                    message: message,
                    delegate: nil,
                    cancelButtonTitle: "Cancel",
                    otherButtonTitles: "Okay")
                    .show();
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }

}
