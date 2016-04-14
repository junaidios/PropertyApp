//
//  OverlayButton.swift
//  Velodrome
//
//  Created by JayD on 13/02/2016.
//  Copyright © 2016 Junaid iOS. All rights reserved.
//

import UIKit

class OverlayButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        
//        self.imageView?.image?.imageWithColor(UIColor.whiteColor())
//        self.imageView?.image?.imageWithColor(UIColor.frozieColor())
        
        
//        let origImage = self.imageView!.image;
//        let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
//        self.setImage(tintedImage, forState: .Normal)
//        self.tintColor = UIColor.redColor()
        
    }
    
    override func layoutSubviews() {
        
//        if let image = self.imageView!.image {
//            
//            let img = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
//            
//            self.imageView?.image = img;
//            self.imageView!.tintColor = UIColor.frozieColor()
//            
//        }

    }


}
