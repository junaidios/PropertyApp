//
//  StringExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/22/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    /// Rounds the double to decimal places value
    mutating func roundToPlaces(_ places:Int) -> Double {
//        let divisor = pow(10.0, Double(places))
//        return round(self * divisor) / divisor
        return self;
    }
    
    
    func getCurrencyFormat()->String{
        return "\(self)";
    }
}

extension Float {
    
    var toString : String {
        return String(format:"%0.1f",self);
    }
    
    var cgFloat : CGFloat {
        return CGFloat(self);
    }
}

extension String {
    
    func getCurrencyFormat()->String{
    
        return self;
    }

    var isEmpty : Bool {
        
        return self.trim().length == 0 || self == "(seleccione uno)";
    }
    
    var urlEncoding : String {
        
        return self.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!;
    }
    
    func trim() -> String {
        
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    var numberFormat : String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:Int(self) ?? 0 )) ?? "0.0"
    }
    
    var toNumber : String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1

        var amountWithPrefix = String(format:"%0.1f",Double(self) ?? 0.0);
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, amountWithPrefix.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double/10))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return "0.0"
        }
        
        return formatter.string(from: number)!
    }
    
    var toCurrency : String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    var toDOBDate : Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self) {
            return date;
        }
        
        return nil
    }
    
    var toDate : Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: self) {
            return date;
        }
        if let dateStr = self.components(separatedBy: "T").first {
            var timeStr = self.components(separatedBy: "T").last?.components(separatedBy: ".").first!;
            timeStr = dateStr + " " + timeStr!;
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: timeStr!) {
                return date;
            }
        }
        
        return Date()
    }
    
    
    static func stringValue(_ object: Any?) -> String {
        
        var value = "";
        
        if let strValue = object as? String {
            
            value = strValue;
        }
        else if let strValue = object as? NSNumber {
            
            value = strValue.stringValue;
        }
        return value;
    }
    
    static func numberValue(_ object: AnyObject?) -> NSNumber {
        
        
        var value = NSNumber();
        
        value = 0.0;
        
        if var strValue = object as? String {
            
            strValue = strValue.replacingOccurrences(of: " ", with: "");
            strValue = strValue.replacingOccurrences(of: "$", with: "");
            
            if let val = Float(strValue) {
                
                value = NSNumber(value: val);
            }
        }
        else if let strValue = object as? NSNumber {
            
            value = strValue;
        }
        return value;
    }
    
    
    static func toJSonString(data : Any) -> String {
        
        var jsonString = "";
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .init(rawValue: 0))
            jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
        } catch {
            print(error.localizedDescription)
        }
        
        return jsonString;
    }
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
    
    var length: Int {
        return self.count
    }
    
    var objcLength: Int {
        return self.utf16.count
    }
    
    
    func setupMessageAndBoldText(_ text: String) -> NSAttributedString {
        
        let string = NSMutableAttributedString(string: self)
        
        string.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 15.0) as Any,
                            range: (self as NSString).range(of:self))
        
        string.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: (self as NSString).range(of: self))
        
        let selectedRange = (self as NSString).range(of:text)
        
        string.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 15.0), range: selectedRange)
        string.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.orange, range: selectedRange)
        
        return string
    }
    
    //MARK: - Linguistics
    
    /**
     Returns the langauge of a String
     
     NOTE: String has to be at least 4 characters, otherwise the method will return nil.
     
     - returns: String! Returns a string representing the langague of the string (e.g. en, fr, or und for undefined).
     */
    func detectLanguage() -> String? {
        if self.length > 4 {
            let tagger = NSLinguisticTagger(tagSchemes:[NSLinguisticTagScheme.language], options: 0)
            tagger.string = self
            return tagger.tag(at: 0, scheme: NSLinguisticTagScheme.language, tokenRange: nil, sentenceRange: nil).map { $0.rawValue }
        }
        return nil
    }
    
    /**
     Returns the script of a String
     
     - returns: String! returns a string representing the script of the String (e.g. Latn, Hans).
     */
    func detectScript() -> String? {
        if self.length > 1 {
            let tagger = NSLinguisticTagger(tagSchemes:[NSLinguisticTagScheme.script], options: 0)
            tagger.string = self
            return tagger.tag(at: 0, scheme: NSLinguisticTagScheme.script, tokenRange: nil, sentenceRange: nil).map { $0.rawValue }
        }
        return nil
    }
    
    /**
     Check the text direction of a given String.
     
     NOTE: String has to be at least 4 characters, otherwise the method will return false.
     
     - returns: Bool The Bool will return true if the string was writting in a right to left langague (e.g. Arabic, Hebrew)
     
     */
    var isRightToLeft : Bool {
        let language = self.detectLanguage()
        return (language == "ar" || language == "he")
    }
    
    
    //MARK: - Usablity & Social
    
    /**
     Check that a String is only made of white spaces, and new line characters.
     
     - returns: Bool
     */
    func isOnlyEmptySpacesAndNewLineCharacters() -> Bool {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).length == 0
    }
    
    var isValidEmail: Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
    /**
     Checks if a string is an email address using NSDataDetector.
     
     - returns: Bool
     */
    var isEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, length))
        
        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }
    
    /**
     Check that a String is 'tweetable' can be used in a tweet.
     
     - returns: Bool
     */
    func isTweetable() -> Bool {
        let tweetLength = 140,
        // Each link takes 23 characters in a tweet (assuming all links are https).
        linksLength = self.getLinks().count * 23,
        remaining = tweetLength - linksLength
        
        if linksLength != 0 {
            return remaining < 0
        } else {
            return !(self.utf16.count > tweetLength || self.utf16.count == 0 || self.isOnlyEmptySpacesAndNewLineCharacters())
        }
    }
    
    /**
     Gets an array of Strings for all links found in a String
     
     - returns: [String]
     */
    func getLinks() -> [String] {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        let links = detector?.matches(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, length)).map {$0 }
        
        return links!.filter { link in
            return link.url != nil
            }.map { link -> String in
                return link.url!.absoluteString
        }
    }
    
    /**
     Gets an array of URLs for all links found in a String
     
     - returns: [NSURL]
     */
    func getURLs() -> [URL] {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        let links = detector?.matches(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, length)).map {$0 }
        
        return links!.filter { link in
            return link.url != nil
            }.map { link -> URL in
                return link.url!
        }
    }
    
    
    /**
     Gets an array of dates for all dates found in a String
     
     - returns: [NSDate]
     */
    func getDates() -> [Date] {
        let error: NSErrorPointer = nil
        let detector: NSDataDetector?
        do {
            detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
        } catch let error1 as NSError {
            error?.pointee = error1
            detector = nil
        }
        let dates = detector?.matches(in: self, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSMakeRange(0, self.utf16.count)) .map {$0 }
        
        return dates!.filter { date in
            return date.date != nil
            }.map { link -> Date in
                return link.date!
        }
    }
    
    /**
     Gets an array of strings (hashtags #acme) for all links found in a String
     
     - returns: [String]
     */
    func getHashtags() -> [String]? {
        let hashtagDetector = try? NSRegularExpression(pattern: "#(\\w+)", options: NSRegularExpression.Options.caseInsensitive)
        let results = hashtagDetector?.matches(in: self, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, self.utf16.count)).map { $0 }
        
        return results?.map({
            (self as NSString).substring(with: $0.range(at: 1))
        })
    }
    
    /**
     Gets an array of distinct strings (hashtags #acme) for all hashtags found in a String
     
     - returns: [String]
     */
    func getUniqueHashtags() -> [String]? {
        return Array(Set(getHashtags()!))
    }
    
    
    
    /**
     Gets an array of strings (mentions @apple) for all mentions found in a String
     
     - returns: [String]
     */
    func getMentions() -> [String]? {
        let hashtagDetector = try? NSRegularExpression(pattern: "@(\\w+)", options: NSRegularExpression.Options.caseInsensitive)
        let results = hashtagDetector?.matches(in: self, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, self.utf16.count)).map { $0 }
        
        return results?.map({
            (self as NSString).substring(with: $0.range(at: 1))
        })
    }
    
    /**
     Check if a String contains a Date in it.
     
     - returns: Bool with true value if it does
     */
    func getUniqueMentions() -> [String]? {
        return Array(Set(getMentions()!))
    }
    
    
    /**
     Check if a String contains a link in it.
     
     - returns: Bool with true value if it does
     */
    func containsLink() -> Bool {
        return self.getLinks().count > 0
    }
    
    /**
     Check if a String contains a date in it.
     
     - returns: Bool with true value if it does
     */
    func containsDate() -> Bool {
        return self.getDates().count > 0
    }
    
    /**
     - returns: Base64 encoded string
     */
    func encodeToBase64Encoding() -> String {
        let utf8str = self.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        return utf8str.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
    }
    
    /**
     - returns: Decoded Base64 string
     */
    func decodeFromBase64Encoding() -> String {
        let base64data = Data(base64Encoded: self, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        return NSString(data: base64data!, encoding: String.Encoding.utf8.rawValue)! as String
    }
    
    
    
    // MARK: Subscript Methods
    
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
    
    subscript (r: Range<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: r.lowerBound),
        end = characters.index(startIndex, offsetBy: r.upperBound)
        
        return self.substring(with: (start ..< end))
    }
    
    subscript (range: NSRange) -> String {
        let end = range.location + range.length
        return self[(range.location ..< end)]
    }
    
    subscript (substring: String) -> Range<String.Index>? {
        return range(of: substring, options: NSString.CompareOptions.literal, range: (startIndex ..< endIndex), locale: Locale.current)
    }
    
    public static func dateFromString(string: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: string)
    }
    
    var formateHHmma : String {
        
        let time = self;
        
        let dateFormatter = DateFormatter()
        
        if self.length > 5 {
            
            dateFormatter.dateFormat = "HH:mm:ss"
        }
        else {
            
            dateFormatter.dateFormat = "HH:mm"
        }
        
        if let fullDate = dateFormatter.date(from: time) {
            
            dateFormatter.dateFormat = "hh:mm a"
            
            return dateFormatter.string(from: fullDate)
        }
        
        return self;
    }
    
    var formateHHmm : String {
        
        let time = self;
        
        let dateFormatter = DateFormatter()
        
        if self.length > 5 {
            
            dateFormatter.dateFormat = "hh:mm a"
        }
        else {
            
            dateFormatter.dateFormat = "HH:mm"
        }
        
        if let fullDate = dateFormatter.date(from: time) {
            
            dateFormatter.dateFormat = "HH:mm"
            
            return dateFormatter.string(from: fullDate)
        }
        
        return self;
    }
    
    
    func toDateFromApiDate() -> Date {
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = DateFormat.apiDateTime
        let convertedDate = dateFormatter.date(from: self)
        return convertedDate!
    }
    
    var dateValue: Date {
        
        if self == "" {
            
            return Date();
        }
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = DateFormat.apiDateTime
        let convertedDate = dateFormatter.date(from: self)
        return convertedDate!
    }
}

