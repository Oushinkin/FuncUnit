//
//  FuncUnit.swift
//  ll
//
//  Created by Chenhsin Won on 2019/09/19.
//  Copyright © 2019 Chenhsin Won. All rights reserved.
//

import UIKit

// MARK: - Function

/// Use local scope to separate code
///
/// - Parameter closure: Closure achieve
public func scope(_ closure: ()->()) {
    closure()
}


/// Use local scope to separate code
///
/// - Parameters:
///   - appending: Whether appending
///   - closure: Closure achieve
public func scope(_ appending: Bool, closure: ()->()) {
    if appending {
        closure()
    }
}

/// Use local scope to separate code
///
/// - Parameters:
///   - note: Note of this closure todo
///   - appending: Whether appending
///   - closure: Closure achieve
public func scope(_ note: String, appending: Bool, closure: ()->()) {
    if appending {
        closure()
    }
}

/// Print the current file name and the necessary information as parameters with our message
///
/// - Parameters:
///   - message: Message to be printed
///   - file: File name, default = #file
///   - method: Method name, default = #function
///   - line: Line number, default = #line
public func printLog<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}


/// Print the current file name and the necessary information as parameters with our message with tag
///
/// - Parameters:
///   - tag: Tag string
///   - message: Message to be printed
///   - file: File name, default = #file
///   - method: Method name, default = #function
///   - line: Line number, default = #line
public func printLog<T>(_ tag: String, _ message: T, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
    print("👉🏻 [\(tag.uppercased())] \((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}

import CryptoSwift

let __key: Array<UInt8> = "1234567890123456".bytes
let __iv:  Array<UInt8> = "1234561234567890".bytes

/// AES CBC encryption
///
/// - Parameter str: The string to be encrypted
/// - Returns: Encrypted and converted to a string in base64 format
public func aes_cbc_b64_encrypt(_ str: String) -> String? {
    do {
        let aes = try AES(key: __key.bytes, blockMode: CBC(iv: __iv_bytes))
        let eb64 = try aes.encrypt(str.bytes).toBase64()
        return eb64
    } catch  { return nil }
}

/// AES CBC decryption
///
/// - Parameter str: The aes cbc base64 string to decrypt
/// - Returns: Decrypted string
public func aes_cbc_b64_decrypt(_ str: String) -> String? {
    do {
        let aes = try AES(key: __key.bytes, blockMode: CBC(iv: __iv_bytes))
        let dstr = try str.decryptBase64ToString(cipher: aes)
        return dstr
    } catch  { return nil }
}

/// Random number
///
/// - Parameter range: Range like 1...6
/// - Returns: A random number
public func random(in range: Range<Int>) -> Int {
    let count = UInt32(range.upperBound - range.lowerBound)
    return  Int(arc4random_uniform(count)) + range.lowerBound
}

public typealias HexRGB = Int

/// Convert hexadecimal RGB values to UIColor
///
/// - Parameters:
///   - HexRGB: HexRGB string
///   - alpha: Alpha value like 0 ~ 1
///   - p3: Whether it is p3 color gamut, default = true
/// - Returns: UIColor
public func ColorFromHex(_ HexRGB: HexRGB, alpha: Float, p3: Bool = true) -> UIColor {
    let red  : Float = Float((HexRGB & 0xff0000) >> 16) / 255.0
    let green: Float = Float((HexRGB & 0xff00  ) >>  8) / 255.0
    let blue : Float = Float(HexRGB & 0xff     )        / 255.0
    
    if p3 { return UIColor(displayP3Red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha)) }
    else  { return UIColor(         red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha)) }
}

/// Digital zero-fill conversion (two digit)
///
/// - Parameter num: The number to convert
/// - Returns: Converted number
public func getTwoDigitNumberStrWithInt(_ num:Int) -> String {
    return "".appendingFormat("%0.2d", num)
}

/// Digital zero-fill conversion (three digit)
///
/// - Parameter num: The number to convert
/// - Returns: Converted number
public func getThreeDigitNumberStrWithInt(_ num:Int) -> String {
    return "".appendingFormat("%0.3d", num)
}

/// Digital zero-fill conversion (four digit)
///
/// - Parameter num: The number to convert
/// - Returns: Converted number
public func getFourDigitNumberStrWithInt(_ num:Int) -> String {
    return "".appendingFormat("%0.4d", num)
}

/// Digital zero-fill conversion (five digit)
///
/// - Parameter num: The number to convert
/// - Returns: Converted number
public func getFiveDigitNumberStrWithInt(_ num:Int) -> String {
    return "".appendingFormat("%0.5d", num)
}

/// Digital zero-fill conversion (any digit)
///
/// - Parameter num: The number to convert
/// - Returns: Converted number
public func getAnyDigitNumberStrWithInt(_ num:Int, digitNumber:Int) -> String {
    return "".appendingFormat("%0.\(digitNumber)d", num)
}

/// System language
///
/// - Returns: System language
public func currentLanguage() -> String {
    let languages = UserDefaults.standard.object(forKey: "AppleLanguages")
    let preferredLanguage = (languages as! Array<String>)[0]
    let arr = preferredLanguage.components(separatedBy: "-")
    return arr[0]
}

/// Software version number
///
/// - Returns: Software version number
public func majorVersion() -> String {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
}

// MARK: - Delay

typealias DTask = (_ cancel : Bool) -> Void

/// Delay
///
/// - Parameters:
///   - time: Delay time
///   - task: Delaying things to do
/// - Returns: Delay task
@discardableResult func delay(_ time: TimeInterval, task: @escaping ()->()) ->  DTask? {
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    
    var closure: (()->Void)? = task
    var result: DTask?
    
    let delayedClosure: DTask = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) { DispatchQueue.main.async(execute: internalClosure) }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result { delayedClosure(false) }
    }
    
    return result;
}

/// Cancel Delay
///
/// - Parameter task: Delay task
func cancel(_ task: DTask?) { task?(true) }

// MARK: - Refex =~

precedencegroup MatchPrecedence {
    associativity: none
    higherThan: DefaultPrecedence
}

infix operator =~: MatchPrecedence

struct RegexHelper {
    let regex: NSRegularExpression
    
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(_ input: String) -> Bool {
        let matches = regex.matches(in: input, options: [], range: NSMakeRange(0, input.utf16.count))
        return matches.count > 0
    }
}

/// Regular verification
///
/// - Parameters:
///   - lhs: The string to be verified
///   - rhs: The regular expression to match
/// - Returns: Whether it matches
func =~(lhs: String, rhs: String) -> Bool {
    do {
        return try RegexHelper(rhs).match(lhs)
    } catch _ {
        return false
    }
}

// MARK: - extension

extension NSObject {
    /// Copy a object
    func copy<T:NSObject>() throws -> T? {
        let data = try NSKeyedArchiver.archivedData(withRootObject:self, requiringSecureCoding:false)
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
    }
}

extension Int {
    
    /// Returns a string of numbers; less than 100 shows the number itself, more than 100 (including 100) shows 99+
    var format99: String {
        if self >= 100 { return "99+" }
        return String(self)
    }
    
    /// Returns a string of numbers
    var stringValue: String {
        return String(self)
    }
}

extension String {
    
    /// is effective mail
    ///
    /// - Parameter mail: mail String
    /// - Returns: Bool
    func isEffectiveMail() -> Bool {
        return self =~ "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
    }
    
    /// is effective url
    ///
    /// - Parameter url: Url String
    /// - Returns: Bool
    func isEffectiveUrl(_ url: String) -> Bool {
        return  self =~ "(ht|f)tp(s?)\\:\\/\\/[0-9a-zA-Z]([-.\\w]*[0-9a-zA-Z])*(:(0-9)*)*(\\/?)([a-zA-Z0-9\\-\\.\\?\\,\\'\\/\\\\\\+&amp;%\\$#_]*)?"
        //    return true
    }
    
    func ga_widthForComment(fontSize: CGFloat, height: CGFloat = 15) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }
    
    func ga_heightForComment(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)
    }
    
    func ga_heightForComment(fontSize: CGFloat, width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)>maxHeight ? maxHeight : ceil(rect.height)
    }
    
    func convertToDictionary() -> [String:AnyObject]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.init(rawValue: 0)]) as? [String:AnyObject]
            } catch _ { return nil }
        }
        return nil
    }
}

extension Data {
    
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    ///
    /// Convert Data to a hex string
    ///
    /// - Parameter options: HexEncodingOptions
    /// - Returns: Data hex string
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}

extension Date {
    
    /// Get current seconds timestamp string - 10 digits
    var timeStamp: String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
    /// Get current seconds timestamp int - 10 digits
    var timeStampInt: Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        return Int(timeInterval)
    }
    
    /// Get current seconds timestamp string - 13 digits
    var milliStamp: String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    /// Acquisition year
    var year: String {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale.current
        timeFormatter.dateFormat = "yyyy"
        return timeFormatter.string(from: self)
    }
    
    /// Acquisition month
    var month: String {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale.current
        timeFormatter.dateFormat = "MM"
        return timeFormatter.string(from: self)
    }
    
    /// Acquisition day
    var day: String {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale.current
        timeFormatter.dateFormat = "dd"
        return timeFormatter.string(from: self)
    }
    
    /// Acquisition time_24
    var time_24: String {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale.current
        timeFormatter.dateFormat = "HH:mm"
        return timeFormatter.string(from: self)
    }
    
    /// Acquisition week
    var week: String {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale.current
        timeFormatter.dateFormat = "EEEE"
        return timeFormatter.string(from: self)
    }
}

extension UIView {
    
    /// Add a corner radius
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    /// Add partial corner radius
    ///
    /// - Parameters:
    ///   - corners: UIRectCorner like [.topLeft, .topRight]
    ///   - radii: Radius
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    /// Move to the parent view center
    func moveToCenter() {
        if let superView = self.superview {
            self.center = superView.center
        }
    }
}

extension UIView {
    
    /// Init a UIView with UIColor
    ///
    /// - Parameter color: UIColor
    convenience init(color: UIColor) {
        self.init(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 10)))
        self.backgroundColor = color
    }
    
    
    /// Convert to UIImage
    ///
    /// - Returns: UIImage
    func convertToImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /// Convert to resizable UIImage
    ///
    /// - Parameter UIEdgeInsets
    /// - Returns: capInsets: ResizableImage
    public func resizableToResizableImage(capInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)) -> UIImage {
        return self.convertToImage().resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
    }
}

var incidentalKey1:Int = 10011001
var incidentalKey2:Int = 10011001
extension UIView {
    
    /// Incidental string
    var incString: String {
        set {
            objc_setAssociatedObject(self, &incidentalKey1, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            if let rs = objc_getAssociatedObject(self, &incidentalKey1) as? String {
                return rs
            }
            return ""
        }
    }
    
    /// Incidental string
    var incString2: String {
        set {
            objc_setAssociatedObject(self, &incidentalKey2, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            if let rs = objc_getAssociatedObject(self, &incidentalKey2) as? String {
                return rs
            }
            return ""
        }
    }
}

extension UIImage {
    
    /// Save JPG file
    ///
    /// - Parameters:
    ///   - cq: Compression quality
    ///   - path: File path
    /// - Returns: File path
    func saveJPG(compressionQuality cq: CGFloat, filePath path: String) -> String? {
        let filePath = path + Date().milliStamp + ".jpg"
        if let fullPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(filePath) {
            do {
                if let data = self.jpegData(compressionQuality: cq) {
                    try data.write(to: fullPath, options: Data.WritingOptions.atomic)
                    return filePath
                }
                return nil
            } catch { return nil }
        }
        return nil
    }
}

protocol NibLoadable { }
extension NibLoadable where Self : UIView {
    
    /// Custom UIView load with XIB, like let demoView = DemoView.loadFromNib()
    ///
    /// - Parameter nibname: Name of nib
    /// - Returns: UIView
    static func loadFromNib(_ nibname: String? = nil) -> Self { //Self (大写) 当前类对象, self (小写) 当前对象
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}

/// Navigation return protocol
@objc protocol NavigationProtocol {
    
    @objc optional func navigationShouldPopMethod() -> Bool
}

extension UIViewController: NavigationProtocol {
    
    /// 重写此方法截断右滑返回并自定义操作
    /// ``` swift
    /// // this is a use demo
    /// override func navigationShouldPopMethod() -> Bool {
    ///     infoTextField.endEditing(true)
    ///
    ///     guard isEdit else { return true }
    ///     let alert = SCLAlertView(appearance: __appearance_alert)
    ///     alert.addButton("放弃修改", backgroundColor: UIColor(.minor), textColor: UIColor(.white), showTimeout: nil) { [weak self] in
    ///         self?.navigationController?.popViewController(animated: true)
    ///     }
    ///     alert.addButton("继续编辑", backgroundColor: UIColor(.normal), textColor: UIColor(.white), showTimeout: nil) { }
    ///     alert.showAlert(with: "修改尚未保存,确定返回?")
    ///
    ///     return false
    /// }
    ///```
    ///
    /// - Returns: Bool
    func navigationShouldPopMethod() -> Bool {
        return true
    }
}

extension UINavigationController: UINavigationBarDelegate, UIGestureRecognizerDelegate {
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if viewControllers.count < (navigationBar.items?.count)! { return true }
        var shouldPop = false
        let vc: UIViewController = topViewController!
        if vc.responds(to: #selector(navigationShouldPopMethod)) { shouldPop = vc.navigationShouldPopMethod() }
        if shouldPop {
            DispatchQueue.main.async { [weak self] in
                self?.popViewController(animated: true)
            }
        } else {
            for subview in navigationBar.subviews {
                if 0.0 < subview.alpha && subview.alpha < 1.0 {
                    UIView.animate(withDuration: 0.25) { subview.alpha = 1.0 }
                }
            }
        }
        return false
    }
    
    /// Add a system edge gesture to the UINavigationController of the rewritten leftBarButtonItem
    /// Just add this delegate to NavigationController: interactivePopGestureRecognizer?.delegate = self
    /// and not need white this to every NavigationController
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if children.count == 1 {
            return false
        } else {
            if topViewController?.responds(to: #selector(navigationShouldPopMethod)) != nil {
                return topViewController!.navigationShouldPopMethod()
            }
            return true
        }
    }
}
