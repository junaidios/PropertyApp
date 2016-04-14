//
//  JSView.swift
//  Velodrome
//
//  Created by JayD on 31/01/2016.
//  Copyright © 2016 Junaid iOS. All rights reserved.
//

import UIKit

class JSView: UIView {

    var rc = false;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        

    }
    
    override func layoutSubviews() {
        
        if ( rc ){
    
            self.layer.cornerRadius = self.frame.size.width / 2.0;
            self.clipsToBounds = true;
        }
    }
}
