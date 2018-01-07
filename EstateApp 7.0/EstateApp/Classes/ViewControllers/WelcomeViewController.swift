//
//  WelcomeViewController.swift
//  EstateApp
//
//  Created by JayD on 06/01/2018.
//  Copyright © 2018 Waqar Ahsan. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class WelcomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false);
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLocationPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "SettingControlView") as! SettingControlView
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        UINavigationBar.appearance().tintColor = UIColor.white;
        UINavigationBar.appearance().barTintColor = UIColor.appTheme;
        
        let searchText : NSMutableAttributedString = NSAttributedString(string: "Search").mutableCopy() as! NSMutableAttributedString;
        searchText.setAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.lightText], range: NSRangeFromString("search"));
        
        UITextField.appearance(whenContainedInInstancesOf:([UISearchBar.self])).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,NSAttributedStringKey.strokeColor.rawValue : UIColor.white];
        UITextField.appearance(whenContainedInInstancesOf:([UISearchBar.self])).attributedPlaceholder = searchText
            
//(UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])).attributedPlaceholder = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]


        
        SlideMenuOptions.leftViewWidth = UIScreen.main.bounds.width * 0.80;
        SlideMenuOptions.contentViewScale = 1.0
        SlideMenuOptions.panGesturesEnabled = false;
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
      
        self.present(slideMenuController, animated: false, completion: nil);
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
