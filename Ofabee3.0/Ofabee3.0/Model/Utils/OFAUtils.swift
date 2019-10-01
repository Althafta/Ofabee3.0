//  OFUtils.swift
//  Ofabee_OLP
//
//  Created by Enfin_iMac on 10/08/17.
//  Copyright © 2017 enfin. All rights reserved.
//

import UIKit
import AVFoundation
import DeviceCheck
import CommonCrypto

class OFAUtils: NSObject {
    class func delay(seconds: Double, completion:@escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    func getBlueColor()->UIColor{
        return UIColor(red:0.16, green:0.58, blue:0.85, alpha:1.0)
    }
    func getSelectedCellBackGroundColor()->UIColor{
        return UIColor(red:0.76, green:0.87, blue:0.98, alpha:1.0)
    }

    class func getDeviceVersion()->String?{
        let deviceVersion=UIDevice.current.systemVersion
        print(deviceVersion)
        return deviceVersion
    }
    
    class func getBuildNumber()->String{
        return   Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
//    class func showAlertViewWithTitle(_ title:String?,message:String?,cancelButtonTitle:String?){
//        UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelButtonTitle).show()
//    }
    class func showAlertViewControllerWithTitle(_ title:String?,message:String?,cancelButtonTitle:String?){
        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
        let nav = appDelegate.window?.rootViewController
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .default, handler: { (alert) -> Void in
            nav?.dismiss(animated: true, completion: nil)
        }))
        nav?.present(alert, animated: true, completion: nil)
    }
    
    class func showAlertViewControllerWithinViewControllerWithTitle(viewController:UIViewController, alertTitle:String?,message:String?,cancelButtonTitle:String?){
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .default, handler: { (alert) -> Void in
            viewController.view.endEditing(true)
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func getDeviceID()->String{
        let deviceID = UIDevice.current.identifierForVendor?.uuidString
        print("Device Token = \(deviceID!)")
        return deviceID!//String(describing: UserDefaults.standard.value(forKey: device_token))
    }
    
    class func getAppVersion()->String{
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        return nsObject as! String
    }
    class func checkEmailValidation(_ stringEmail:String)->Bool{
//        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailTest.evaluate(with: stringEmail)
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: stringEmail)
    }
    
    class func showLoadingViewWithTitle(_ title:String?){
        var loadingView : SwiftLoader.Config = SwiftLoader.Config()
        loadingView.size = 120
        loadingView.backgroundColor=UIColor.clear
        loadingView.spinnerColor=UIColor.lightGray
        loadingView.titleTextColor = UIColor.white
        loadingView.spinnerLineWidth=2.0
        loadingView.foregroundColor=UIColor.black
        loadingView.foregroundAlpha=0.75
        SwiftLoader.setConfig(loadingView)
        SwiftLoader.show(title, animated: true)
    }
    class func removeLoadingView(_ title:String?){
        if(title==nil){
            SwiftLoader.hide()
        }
        else{
            SwiftLoader.show(title, animated: false)
            delay(seconds: 1.2) { () -> () in
                SwiftLoader.hide()
            }
        }
    }
    
    class func getShadowForCell(cell:UITableViewCell){
        cell.layer.shadowColor = self.getColorFromHexString(barTintColor).cgColor
        cell.layer.shadowOffset = CGSize(width: 1, height: 0)
        let shadowFrame = CGRect(x: 0, y: cell.frame.height-1, width: cell.frame.width, height: 2)
        let shadowPath = UIBezierPath(rect: shadowFrame).cgPath
        cell.layer.shadowPath = shadowPath
        cell.layer.shadowOpacity = 0.5
    }
    
    class func getColorFromHexString (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    class func isiPhone()->Bool{
        if(UIDevice.current.userInterfaceIdiom==UIUserInterfaceIdiom.pad){
            return false
        }
        else{
            return true
        }
    }
    class func getFileName(_ prefixName:String?,Extension:String?)->String {
        let  dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd_MM_yy_hh_mm_ss_SSS"
        let uniqueFileName = dateFormatter.string(from: Date())
        let fileName = prefixName!+"_"+uniqueFileName+Extension!
        return fileName
    }
    class func getProfilePicPlaceHolder()->UIImage{
        return UIImage(named: "profilePic")!
    }
    class func createNewFolderWithName(_ folderName:String)->String{
        let dataPath = OFAUtils.getDocumentDirectoryPath() + folderName
        let directoryStatus : Bool = FileManager.default.fileExists(atPath: dataPath)
        if !directoryStatus {
            do {
                try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                let error = error as NSError
                print(error)
            }
        }
        return dataPath
    }
    class func getDocumentDirectoryPath()->String{
        let arrayPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory  = arrayPaths.first
        return documentDirectory!
    }
    class func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    class func getStringFromMilliSecondDate(date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat="dd/MM/yyyy"
        let local = Locale(identifier: "en_US")
        formatter.locale=local
        return formatter.string(from: date)
    }
    class func getDateTimeFromString(_ stringDate:String)->Date{
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "HH:mm:ss"
        let local = Locale(identifier: "en_US")
        formatter.locale=local
        return formatter.date(from: stringDate)!
    }
    class func getDateFromString(_ stringDate:String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let local = Locale(identifier: "en_US")
        dateFormatter.locale=local
        return dateFormatter.date(from: stringDate)!
    }
    class func getUpdatedAtDate(_ stringDate:String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="dd-MM-yyyy HH:mm:ss"
        let local = Locale(identifier: "en_US")
        dateFormatter.locale=local
        return dateFormatter.date(from: stringDate)!
    }
    class func getUpdatedAtDateString(_ date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat="dd-MM-yyyy HH:mm:ss"
        let local = Locale(identifier: "en_US")
        formatter.locale=local
        return formatter.string(from: date)
    }
    class func getStringTimeFromDate(_ date:Date)->String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.dateFormat = "hh:mm a"
        let local = Locale(identifier: "en_US")
        formatter.locale=local
        return formatter.string(from: date)
    }
    class func getCurrentDateTime()->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="dd-MM-yyyy HH:mm:ss"
        let currentDataString = dateFormatter.string(from: Date())
        return dateFormatter.date(from: currentDataString)!
    }
    class func getStringFromDate(_ date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat="HH:mm:ss"
        let local = Locale(identifier: "en_US")
        formatter.locale=local
        return formatter.string(from: date)
    }
    class func getDateStringFromDate(_ date:Date)->String{ 
        let formatter = DateFormatter()
        //        formatter.dateStyle = .FullStyle
        //        formatter.timeStyle = .NoStyle
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let local = Locale(identifier: "en_US")
        formatter.locale=local
        return formatter.string(from: date)
    }
    class func getExtensionOFFileName(_ fileName:String)->String
    {
        let arrayName = fileName.components(separatedBy: ".")
        let type = arrayName.last!
        return type
    }
//    class func getAttachedFileUrlString(activity_id:String,fileName:String)->String{
//        let urlString = activityAttachFileUrl+"\((activity_id))/" + fileName
//        return urlString
//    }
    class func getDocumentDirectoryFilePath(_ activity_id:String,user_id:String,file_name:String)->String{
        let documentDirectoryPath = OFAUtils.getDocumentDirectoryPath()
        let path = "\(documentDirectoryPath)/MyToDo_ActivityFiles/\(user_id)/\(activity_id)/\(file_name)"
        print(path)
        return path
    }
    func videoSnapshot(_ filePathLocal: NSString) -> UIImage? {
        
        let videoURL = URL(fileURLWithPath:filePathLocal as String)
        let asset = AVURLAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 2, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    func getPreviewImageForVideoAtURL(_ videoURL: URL, atInterval: Int) -> UIImage? {
        print("Taking pic at \(atInterval) second")
        let asset = AVAsset(url: videoURL)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(Float64(atInterval), preferredTimescale: 100)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let frameImg = UIImage(cgImage: img)
            return frameImg
        } catch {
            /* error handling here */
        }
        return nil
    }
    class func getCategoryUsingIndexPath(_ indexPath:IndexPath)->String{
        let section = (indexPath as NSIndexPath).section+1
        return "\(section)"
    }
    class func isWhiteSpace(_ input: String) -> Bool {
        let letters = CharacterSet.alphanumerics
        let phrase = input
        let range = phrase.rangeOfCharacter(from: letters)
        return range == nil ? true : false
    }
    class func trimWhiteSpaceInString(_ string:String)->String{
        let trimmedString = string.trimmingCharacters(in: CharacterSet.whitespaces)
        return trimmedString
    }
    class func showToastWithTitle(_ title:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let winDow = appDelegate.window?.rootViewController
        winDow?.view.makeToast(title, duration: 2, position: ToastPosition.bottom)
    }
    class func getResizedImagefromImage(_ image:UIImage?,scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    class func setBackgroundForTableView(tableView:UITableView){
        let imageView = UIImageView(image: UIImage(named: "AppBG_iPhone"))
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 1.0
//        tableView.backgroundColor = CAUtils.getColorFromHexString(barTintColor)
        
        let bottomImageView = UIImageView(image: UIImage(named: "AppBG_iPad"))
        bottomImageView.contentMode = .scaleAspectFill
        bottomImageView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 376)
        bottomImageView.alpha = 1.0
        
        let view = UIView(frame: self.isiPhone() ? imageView.frame : tableView.frame)
        
        view.backgroundColor = .white
        view.alpha = 0.5
        imageView.addSubview(view)
        bottomImageView.addSubview(view)
        if !self.isiPhone(){
            tableView.backgroundView = bottomImageView
        }else{
            tableView.backgroundView = imageView
        }
    }
    
    class func getRandomColor() -> UIColor {
        let randomRed = CGFloat(drand48())
        let randomGreen = CGFloat(drand48())
        let randomBlue = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    class func getRandomTransactionID(length:Int) -> String{
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    class func getDoneToolBarButton(tableView:UITableViewController,target:Selector?)-> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.red//UIColor(red: 0/255, green: 103/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Dismiss", style: .plain, target: tableView, action: target)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: tableView, action: nil)
        toolBar.setItems([flexibleSpace,doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
    class func getHTMLAttributedString(htmlString:String) -> String{
        var originalString = ""
        do {
            let attrStr = try NSAttributedString(data: htmlString.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                                                 options: [ NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.documentType.rawValue): NSAttributedString.DocumentType.html],
                                                 documentAttributes: nil)
            originalString = attrStr.string
        }catch{
            originalString = "Invalid String"
        }
//        let returnString = originalString.components(separatedBy: "\n")[0]
        return originalString// OFAUtils.trimWhiteSpaceInString(returnString)
    }
    
    class func getHTMLAttributedStringForAssessmetOptions(htmlString:String) -> String{
        var originalString = ""
        do {
            let attrStr = try NSAttributedString(data: htmlString.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                                                 options: [ NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.documentType.rawValue): NSAttributedString.DocumentType.html],
                                                 documentAttributes: nil)
            originalString = attrStr.string
        }catch{
            originalString = "Invalid String"
        }
        let returnString = originalString.components(separatedBy: "\n")[0]
        return OFAUtils.trimWhiteSpaceInString(returnString)
    }
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
    class func getYoutubeId(youtubeUrl: String) -> String {
        return youtubeUrl.youtubeID!
    }
    
    class func getTimeStamp() -> String{
        let date = self.getCurrentDateTime()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let local = Locale(identifier: "en_US")
        formatter.locale=local
        return formatter.string(from: date)
    }
    
    class func getJSONStringFromDictionary(dicParameter:NSDictionary) -> String{
        let jsonData = try! JSONSerialization.data(withJSONObject: dicParameter, options: .sortedKeys)
        return String(data: jsonData, encoding: .utf8)!
    }
    
    /*
    class func isNetworkAvailable()->Bool {
        let status = CAReachability().connectionStatus()
        switch status {
        case .unknown, .offline:
            CAUtils.showToastWithTitle("Connect to network")
            return false
        case .online(.wwan):
            return true
        case .online(.wiFi):
            return true
        }
    }
 */
}

enum HMACAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func toCCHmacAlgorithm() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}
extension String {
    
    //MARK:- Youtube ID REGEX
    
    var youtubeID: String? {
        let rule = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: rule, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        guard let checkingResult = regex?.firstMatch(in: self, options: [], range: range) else { return nil }
        
        return (self as NSString).substring(with: checkingResult.range)
    }
    
    //MARK:- SHA256 Hash
    
    func hmac(algorithm: HMACAlgorithm, key: String) -> String {
        let cKey = key.cString(using: String.Encoding.utf8)
        let cData = self.cString(using: String.Encoding.utf8)
        var result = [CUnsignedChar](repeating: 0, count: Int(algorithm.digestLength()))
        CCHmac(algorithm.toCCHmacAlgorithm(), cKey!, strlen(cKey!), cData!, strlen(cData!), &result)
        let hmacData:NSData = NSData(bytes: result, length: (Int(algorithm.digestLength())))
        let hmacBase64 = hmacData.base64EncodedString(options: .lineLength76Characters)
        return String(hmacBase64)
    }
}

// trying to change font color by finding the average color

extension UIImage {
    func areaAverage() -> UIColor {
        var bitmap = [UInt8](repeating: 0, count: 4)
        
        if #available(iOS 9.0, *) {
            // Get average color.
            let context = CIContext()
            let inputImage = ciImage ?? CoreImage.CIImage(cgImage: cgImage!)
            let extent = inputImage.extent
            let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
            let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputExtent])!
            let outputImage = filter.outputImage!
            let outputExtent = outputImage.extent
            assert(outputExtent.size.width == 1 && outputExtent.size.height == 1)
            
            // Render to bitmap.
            context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: CIFormat.RGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        } else {
            // Create 1x1 context that interpolates pixels when drawing to it.
            let context = CGContext(data: &bitmap, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGBitmapInfo().rawValue | CGImageAlphaInfo.premultipliedLast.rawValue)!
            let inputImage = cgImage ?? CIContext().createCGImage(ciImage!, from: ciImage!.extent)
            
            // Render to bitmap.
            context.draw(inputImage!, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        }
        
        // Compute result.
        let result = UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
        return result
    }
}

public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad7,11", "iPad7,12":                    return "iPad 7"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad Mini 5"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}
