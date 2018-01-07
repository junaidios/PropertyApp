//
//  UIImageView.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/3/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {
    
    func setImageWithURI(_ strURL: String) {
        
//        self.image = #imageLiteral(resourceName: "loading");
        
        if let url = URL(string: strURL) {
            
            self.af_setImage(withURL: url, placeholderImage: UIImage(named: "imagePP"));
        }
    }
  
}

extension UIButton {
    
    func setImageWithURL(_ strURL: String) {
    
    }
}

