//
//  UIApplication.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/11/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//
import UIKit


extension CALayer {
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
}

public extension UIView {
    
    func borderUIColor(color : UIColor)
    {
        self.layer.borderWidth = self.layer.borderWidth == 0 ? 1 : self.layer.borderWidth
        self.layer.borderColor = color.cgColor;
    }
    
    func round()
    {
        self.layer.cornerRadius = self.frame.width/2.0;
        self.layer.masksToBounds = true;
    }
    
    func cornerRadius(_ radius: CGFloat)
    {
        self.layer.cornerRadius = radius;
        self.layer.masksToBounds = true;
    }
    
    func addConstraint(attribute: NSLayoutAttribute, view: UIView, constant: CGFloat) -> Void {
        
        let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1, constant: constant)
        
        view.addConstraint(constraint)
    }
    
    func addConstraintSize(attribute: NSLayoutAttribute, constant: CGFloat) -> Void {
        
        let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constant)
        
        self.addConstraint(constraint)
    }
    
    
    func hardCopy() -> UIView {
        
        let archivedData = NSKeyedArchiver.archivedData(withRootObject: self);
        
        let  newView = NSKeyedUnarchiver.unarchiveObject(with: archivedData);
        
        return newView as! UIView;
    }
    
    func addBorder(withRadius radius: CGFloat) {
        let layer = self.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
    
    func addBorder(color: UIColor, andRadius radius: CGFloat) {
        let layer = self.layer;
        layer.masksToBounds = true;
        layer.borderColor = color.cgColor;
        layer.borderWidth = 1.0;
        layer.cornerRadius = radius;
    }
    
    func addBorderWithShadow(withRadius radius: CGFloat) {
        let layer = self.layer
        layer.masksToBounds = false
        layer.cornerRadius = radius
        layer.shadowOpacity = 0.50
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 1
    }
}


extension UICollectionView {
    
    var currentPage : Int {
        
        let pageWidth = self.frame.size.width;
        return Int(self.contentOffset.x / pageWidth);
    }
    
    var totalPage : Int {
        
        let pageWidth = self.frame.size.width;
        return Int(self.contentSize.width / pageWidth);
    }
}
extension UIViewController {
    
    func popControllersToLevels(level: Int) {
        
        if (self.navigationController?.viewControllers.count)! > level {
            
            let controllerNumber = ((self.navigationController?.viewControllers.count)! - 1) - level;
            self.navigationController!.popToViewController((self.navigationController?.viewControllers[controllerNumber])!, animated: true);
        }
        
    }
    
    func showDialog(msg:String, handler : ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: "Alert", message:msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
}



extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

