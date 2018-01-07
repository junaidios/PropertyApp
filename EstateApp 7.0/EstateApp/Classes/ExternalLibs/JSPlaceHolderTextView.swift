//
//  JSPlaceHolderTextView.swift
//  GoPatoDrive
//
//  Created by JayD on 12/11/2016.
//  Copyright © 2016 Tafveez Mehdi. All rights reserved.
//

import UIKit

class JSPlaceHolderTextView: UITextView {
    
    var placeholder: String?
    
    var placeholderColor: UIColor?
    
    override var text: String? {
        didSet{
            
        }
    }
    
    var padding = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0);
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        if placeholder == nil { placeholder = "" }
        if placeholderColor == nil { placeholderColor = UIColor.lightGray }
        NotificationCenter.default.addObserver(self, selector: #selector(JSPlaceHolderTextView.textChanged(notificationL:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder);
        
        if placeholder == nil { placeholder = "" }
        if placeholderColor == nil { placeholderColor = UIColor.lightGray }
        NotificationCenter.default.addObserver(self, selector: #selector(JSPlaceHolderTextView.textChanged(notificationL:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
        self.textContainerInset = padding;
    }
    
    
    private var placeHolderLabel: UILabel?
    
    override func draw(_ rect: CGRect) {
        
        if (placeholder?.length)! > 0 {
            
            if placeHolderLabel == nil {
                placeHolderLabel = UILabel()
                placeHolderLabel?.font = self.font
                placeHolderLabel?.textColor = placeholderColor
                placeHolderLabel?.alpha = 0
                placeHolderLabel?.tag = 999
                placeHolderLabel?.numberOfLines = 0;
                placeHolderLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
                self.addSubview(placeHolderLabel!)
            }
            
            placeHolderLabel?.text = placeholder
            placeHolderLabel?.frame = CGRect(x: 3, y: padding.top, width: self.bounds.width, height: self.bounds.height)
            placeHolderLabel?.sizeToFit()

            self.sendSubview(toBack: placeHolderLabel!)
        }
        
        if self.text!.length == 0 && (placeholder?.length)! > 0 {
            self.viewWithTag(999)?.alpha = 1
        }
        super.draw(rect)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if placeholder == nil { placeholder = "" }
        if placeholderColor == nil { placeholderColor = UIColor.lightGray }
        font = self.font
        NotificationCenter.default.addObserver(self, selector: #selector(JSPlaceHolderTextView.textChanged(notificationL:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
        
    }
    @objc func textChanged(notificationL: NSNotification) {
        
        if placeholder?.length == 0 {
            return
        }
        UIView.animate(withDuration: 0.25) { () -> Void in
            if self.text!.length == 0 {
//                self.viewWithTag(999)?.alpha = 1
            } else {
//                self.viewWithTag(999)?.alpha = 0
            }
        }
        
        if self.text!.length > 0 {
            padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16);
            placeHolderLabel?.frame = CGRect(x: 3, y: 0, width: self.bounds.width, height: self.bounds.height)
            placeHolderLabel?.sizeToFit()
            placeHolderLabel?.font = self.font?.withSize(10);
        }
        else {
            padding = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 16);
            placeHolderLabel?.frame = CGRect(x: 3, y: padding.top, width: self.bounds.width - (padding.left + padding.left), height: 16)
            placeHolderLabel?.font = self.font
        }
    }
}
