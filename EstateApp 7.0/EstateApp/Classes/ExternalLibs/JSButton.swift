
//
//  JSButton.swift
//  Velodrome
//
//  Created by JayD on 11/04/2016.
//  Copyright © 2016 Junaid iOS. All rights reserved.
//

import UIKit

class JSButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
    }
    
//    override func layoutSubviews() {
//        
//        if ( rc ){
//            
//            self.layer.cornerRadius = self.frame.size.width / 2.0;
//            self.clipsToBounds = true;
//        }
//    }

    @objc override var isHighlighted: Bool {
        didSet {
            
            if isHighlighted {

                self.touchDownAnimation();
            } else {
                
                self.touchUpAnimation();
            }
        }
    }
    
    func touchDownAnimation() {
    
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
        self.layer.transform = CATransform3DMakeScale(0.90, 0.90, 0.90);

        })
    }
    
    func touchUpAnimation() {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.layer.transform = CATransform3DIdentity;
            
        })
    }
}
