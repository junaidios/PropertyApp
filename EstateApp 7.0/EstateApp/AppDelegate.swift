//
//  AppDelegate.swift
//  EstateApp
//
//  Created by JayD on 26/05/2015.
//  Copyright (c) 2015 Waqar Ahsan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
//    func factorial(fact : Int) -> Int {
//        
//        if fact <= 1{
//            return 1;
//        }
//        else {
//        
//            let fact = fact * factorial(fact-1);
//        
//            return fact;
//        }
//    }


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        
//        print(factorial(5));
        
//        UserService.loadUserProfile("yasir@realstrategic.co", password: "Yas@strategic", success: { (data) -> () in
//            
//            
//            UIAlertView(title: "Test App", message: "Success", delegate: nil, cancelButtonTitle: "Cancel").show()
//
//            
//        }) { (error) -> () in
//            
//            UIAlertView(title: "Test App", message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "Cancel").show()
//            
//        };
        
        
//        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        let leftViewController = storyboard.instantiateViewControllerWithIdentifier("SettingControlView") as! SettingControlView
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor();
        UINavigationBar.appearance().barTintColor = UIColor.blueThemeColor();
        
        let barAppearace = UIBarButtonItem.appearance()
        barAppearace.setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics:UIBarMetrics.Default)  // 2
       
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
//
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

