//
//  Extension.swift
//  Life Service
//
//  Created by cano on 03/01/22.
//

import Foundation
import UIKit

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
//MARK: -
class Text: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 15)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
//extension UIColor {
//    static let background = UIColor(named: "background")
//    static let defaultTint = UIColor(named: "defaultTint")
//    static let cell_background = UIColor(named: "cell_background")
//
//    struct Navigation {
//        static let background = UIColor(named: "navigation_background")
//    }
//
//    struct TabBar {
//        static let itemBackground = UIColor(named: "tabItem_background")
//        static let title = UIColor(named: "title")
//    }
//}

//MARK: -  Select button show Border color
///240, 122, 57, 1)
class MyButton: UIButton
 {
     override var isSelected: Bool{
         didSet {
             switch isSelected {
             case true:
                layer.borderColor = UIColor.init(red: 240.0/255, green: 122.0/255, blue: 57.0/255, alpha: 1.0).cgColor
                 layer.borderWidth = 1
                layer.cornerRadius = 13
             case false:
                 layer.borderColor = UIColor.white.cgColor
                 layer.borderWidth = 1
                layer.cornerRadius = 13
             }
         }
     }
 }


// MARK: - Alert message

extension UIViewController {
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Note", message:
                                                    message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
        })
        )
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertOnSelf(message:String) {
            let alertViewController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertViewController.addAction(okAction)
            self.present(alertViewController, animated: true, completion: nil)
        }
    
    
   
      func isValidEmail(test: String) -> Bool {
          let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

          let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return emailTest.evaluate(with: test)
      }
    
    func imageToBase64First(_ image: UIImage) -> String? {
            return image.jpegData(compressionQuality: 0.2)?.base64EncodedString(options: .init(rawValue: 0))
       
        }
    func showAlertWithCompletion(title:String,message:String,completion:((UIAlertAction) -> Void)? = nil){
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelBtn = UIAlertAction(title: "OK", style: .default, handler: completion)
            let okBtn = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(okBtn)
            alertController.addAction(cancelBtn)
            self.present(alertController, animated: true, completion: nil)
        }
    
    func showAlertWithResendCompletion(title:String,message:String,completion:((UIAlertAction) -> Void)? = nil){
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let resendBtn = UIAlertAction(title: "Resend", style: .default, handler: completion)
            let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(resendBtn)
            alertController.addAction(okBtn)
            self.present(alertController, animated: true, completion: nil)
        }
    
    
    
    
    
    func showAlertWithOkComplitionHandler(message:String,buttonTitle:String, completionHandler:((UIAlertAction) -> Swift.Void)?) {
           let alertViewController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
           let okAction = UIAlertAction(title: buttonTitle, style: .default, handler: completionHandler)
           alertViewController.addAction(okAction)
           self.present(alertViewController, animated: true, completion: nil)
       }
    
}
//MARK: - Mobile Number Validation

extension String {
    var isPhoneNumber: Bool
    {
        do {
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options:[], range: NSMakeRange(0,self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 &&
                    res.range.length == self.count && self.count == 9
                
            } else {
                return true
            }
        }
    }
}
//MARK: - Device ID
func getDeviceId() -> String{
        
        let strDeviceId: String = UIDevice.current.identifierForVendor!.uuidString
        return strDeviceId
    }

//MARK: - Segment controller

extension UISegmentedControl{
    func removeBorder(){
            let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: self.bounds.size)
            self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
            self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
            self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)

            let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
            self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        }

        func addUnderlineForSelectedSegment(){
            removeBorder()
            let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
            let underlineHeight: CGFloat = 2.0
            let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
            let underLineYPosition = self.bounds.size.height - 1.0
            let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
            let underline = UIView(frame: underlineFrame)
            underline.backgroundColor = UIColor.orange
            underline.tag = 0
            self.addSubview(underline)
        }

        func changeUnderlinePosition(){
            guard let underline = self.viewWithTag(1) else {return}
            let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
            UIView.animate(withDuration: 0.1, animations: {
                underline.frame.origin.x = underlineFinalXPosition
            })
        }
    }

    extension UIImage {

        class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            let graphicsContext = UIGraphicsGetCurrentContext()
            graphicsContext?.setFillColor(color)
            let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
            graphicsContext?.fill(rectangle)
            let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return rectangleImage!
        }
    }


//MARK: -   Open Calender to tap textfeild

extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2
        // iOS 14 and above
        if #available(iOS 14, *) {// Added condition for iOS 14
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: true) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}
//MARK: ------------
extension UITextField {
    
    func InputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .time //2
        // iOS 14 and above
        if #available(iOS 14, *) {// Added condition for iOS 14
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: true) //8
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func TapCancel() {
        self.resignFirstResponder()
    }
    
}

//MARK: -

@IBDesignable extension UITableViewCell {
    @IBInspectable var selectedColor: UIColor? {
        set {
            if let color = newValue {
                selectedBackgroundView = UIView()
                selectedBackgroundView!.backgroundColor = color
            } else {
                selectedBackgroundView = nil
            }
        }
        get {
            return selectedBackgroundView?.backgroundColor
        }
    }
}
//MARK: - html

extension String{
    var HtmlToString:String?{
        guard let data = data(using: .utf8)else {return nil}
        do {
            return try NSAttributedString (data: data, options: [.documentType:NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil) .string
        }catch let error as NSError{
            print(error.localizedDescription)
            return nil
        }
    }
}
func htmlToString(strDescription:String) -> NSAttributedString
   {
   let attrStrOne = try! NSAttributedString(
            data: strDescription.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options:[NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
      //  self.txtViewDescription.attributedText = attrStrOne
   return attrStrOne
   }
//MARK: - check empty data show image

extension UITableView {

    func setEmptyImage(strImage: UIImage) {
        let showImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
        showImg.image = strImage
        showImg.contentMode = .center
        self.backgroundView = showImg
    }
    func restore() {
        self.backgroundView = nil
    }
}

extension UICollectionView {

    func setEmptyImage(strImage: UIImage) {
        let showImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
        showImg.image = strImage
        showImg.contentMode = .center
        self.backgroundView = showImg
    }
    func restore() {
        self.backgroundView = nil
    }
}

//MARK: - Activity indicator

var actView: UIView = UIView()
var loadingView: UIView = UIView()
var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

extension UIViewController {
        func showActivity(myView: UIView, myTitle: String) {
            myView.isUserInteractionEnabled = false
            myView.window?.isUserInteractionEnabled = false
            myView.endEditing(true)
            actView.frame = CGRect(x: 0, y: 0, width: myView.frame.width, height: myView.frame.height)
            actView.center = myView.center
            actView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)

            loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            loadingView.center = myView.center
            loadingView.backgroundColor = .gray
            loadingView.clipsToBounds = true
            loadingView.layer.cornerRadius = 15

            activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
            activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
            activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);

            loadingView.addSubview(activityIndicator)
            actView.addSubview(loadingView)
            //loadingView.addSubview(titleLabel)
            myView.addSubview(actView)
            activityIndicator.startAnimating()
        }
        func removeActivity(myView: UIView) {
            myView.isUserInteractionEnabled = true
            myView.window?.isUserInteractionEnabled = true
            activityIndicator.stopAnimating()
            actView.removeFromSuperview()
        }
}

//MARK: -
//MARK: - Dash View

extension UIView {
    @discardableResult
    func addLineDashedStroke(pattern: [NSNumber]?, radius: CGFloat, color: CGColor) -> CALayer {
        let borderLayer = CAShapeLayer()

        borderLayer.strokeColor = color
        borderLayer.lineDashPattern = pattern
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath

        layer.addSublayer(borderLayer)
        return borderLayer
    }
}

//MARK: -

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

//MARK:- View gesture

extension UIPanGestureRecognizer {

    enum GestureDirection {
        case Up
        case Down
        case Left
        case Right
    }

    /// Get current vertical direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func verticalDirection(target target: UIView) -> GestureDirection {
        return self.velocity(in: target).y > 0 ? .Down : .Up
    }

    /// Get current horizontal direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func horizontalDirection(target target: UIView) -> GestureDirection {
        return self.velocity(in: target).x > 0 ? .Right : .Left
    }

    /// Get a tuple for current horizontal/vertical direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func versus(target target: UIView) -> (horizontal: GestureDirection, vertical: GestureDirection) {
        return (self.horizontalDirection(target: target), self.verticalDirection(target: target))
    }

}
//MARK: -

extension UIImage
{
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    /*func resizeImageRectangle(targetSize: CGSize) -> CGRect {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width  heightRatio, height: size.height  heightRatio)
        } else {
            newSize = CGSize(width: size.width  widthRatio, height: size.height  widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rect
    }*/
    
    public enum DataUnits: String {
            case byte, kilobyte, megabyte, gigabyte
        }

    func getSizeIn(_ type: DataUnits, data:Data)-> String {

            var size: Double = 0.0

            switch type {
            case .byte:
                size = Double(data.count)
            case .kilobyte:
                size = Double(data.count) / 1024
            case .megabyte:
                size = Double(data.count) / 1024 / 1024
            case .gigabyte:
                size = Double(data.count) / 1024 / 1024 / 1024
            }

            return String(format: "%.2f", size)
        }
}


extension CGSize {
    static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
}
extension String {
    
    //MARK:- Validation Methods
    func isValidEmail() -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
    
    func isValidPassword() -> Bool {
       /* //https://www.mkyong.com/regular-expressions/how-to-validate-password-with-regular-expression/
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{6,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        let result = passwordTest.evaluate(with: self)
        return result
        */
        if self.count < 6 {
            return false
        }
        return true
    }
    
    func isValidMobileNumber() -> Bool {
        let string = self.replacingOccurrences(of: "-", with: "")
        let PHONE_REGEX = "^[0-9]{10,10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: string)
        return result
    }
    
    

   
    func getCountryCode() -> String {
        //guard let local = Locale.current.regionCode else { return "+" }
        let prefixCodes = ["AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263"]
        let countryDialingCode = prefixCodes[self.uppercased()] ?? ""
        return "+" + countryDialingCode
    }

    
    func isValidUrl() -> Bool {
        
        if self == self {
            if let url = URL(string: self) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
    
    func isAlphanumeric() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil
        
    }
    
    func isAlphanumericRegularExpression() -> Bool {
        return self.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }

    
//    func validateNullValue() -> String {
//        if self.isEmpty || self == Constant.NULL_STRING || self == Constant.PLACEHOLDER_ADDRESS || self == Constant.PLACEHOLDER_POST_DESCRIPTION || self == Constant.PLACEHOLDER_PREFERED_BARS || self == Constant.PLACEHOLDER_PREFERED_EATS {
//            return ""
//        }
//        return self
//    }
    
    func validateTextEmptySoSetNull() -> String {
        /*if self.isEmpty || self == Constant.TITLE_QUESTION_OR_COMMENT {
            return Constant.NULL_STRING
        }*/
        return self
    }
    
    func getTimeIn12HoursFromate() -> String {
        let inFormatter = DateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        inFormatter.dateFormat = "HH:mm"

        let outFormatter = DateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        outFormatter.dateFormat = "hh:mm a"

        let inStr = self
        let date = inFormatter.date(from: inStr)!
        let outStr = outFormatter.string(from: date)
        return outStr
    }
    

    var phoneFormatted: String {
            let count = self.count
            return self.enumerated().map { $0.offset % 3 == 0 && $0.offset != 0 && $0.offset != count-1 || $0.offset == count-4 && count % 4 != 0 ? "-\($0.element)" : "\($0.element)" }.joined()
        }

    var getPhoneNumberString: String {
        return self.components(separatedBy: .whitespacesAndNewlines).joined().replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
    }
    
    func getDateFromString(gmtString:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: gmtString)
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        
        return date!
    }
    }
    
extension UIImageView {
    func setGIFImage(name: String, repeatCount: Int = 0 ) {
        DispatchQueue.global().async {
            if let gif = UIImage.makeGIFFromCollection(name: name, repeatCount: repeatCount) {
                DispatchQueue.main.async {
                    self.setImage(withGIF: gif)
                    self.startAnimating()
                }
            }
        }
    }

    private func setImage(withGIF gif: GIF) {
        animationImages = gif.images
        animationDuration = gif.durationInSec
        animationRepeatCount = gif.repeatCount
    }
}

extension UIImage {
    class func makeGIFFromCollection(name: String, repeatCount: Int = 0) -> GIF? {
        guard let path = Bundle.main.path(forResource: name, ofType: "gif") else {
            print("Cannot find a path from the file \"\(name)\"")
            return nil
        }

        let url = URL(fileURLWithPath: path)
        let data = try? Data(contentsOf: url)
        guard let d = data else {
            print("Cannot turn image named \"\(name)\" into data")
            return nil
        }

        return makeGIFFromData(data: d, repeatCount: repeatCount)
    }

    class func makeGIFFromData(data: Data, repeatCount: Int = 0) -> GIF? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("Source for the image does not exist")
            return nil
        }

        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        var duration = 0.0

        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)

                let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                                source: source)
                duration += delaySeconds
            }
        }

        return GIF(images: images, durationInSec: duration, repeatCount: repeatCount)
    }

    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.0

        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        if CFDictionaryGetValueIfPresent(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque(), gifPropertiesPointer) == false {
            return delay
        }

        let gifProperties:CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)

        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }

        delay = delayObject as? Double ?? 0

        return delay
    }
}

class GIF: NSObject {
    let images: [UIImage]
    let durationInSec: TimeInterval
    let repeatCount: Int

    init(images: [UIImage], durationInSec: TimeInterval, repeatCount: Int = 0) {
        self.images = images
        self.durationInSec = durationInSec
        self.repeatCount = repeatCount
    }
}
