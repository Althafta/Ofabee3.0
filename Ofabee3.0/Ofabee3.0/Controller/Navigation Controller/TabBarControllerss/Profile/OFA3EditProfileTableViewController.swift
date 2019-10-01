//
//  OFA3EditProfileTableViewController.swift
//  Ofabee3.0
//
//  Created by Enfin on 06/09/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit
import TweeTextField
import Alamofire
import SDWebImage

class OFA3EditProfileTableViewController: UITableViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var textName: TweeAttributedTextField!
    @IBOutlet weak var textPhoneNumber: TweeAttributedTextField!
    @IBOutlet weak var textEmailAddress: TweeAttributedTextField!
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    
    var imagePicker = UIImagePickerController()
    var actionSheet = UIAlertController()
    var pickedImage = UIImage()
    var imageData : Data?
    
    var textFieldLineColor = "EEEEEE"
    var textFieldPlaceHolderColor = "888888"
    
    let accessToken = UserDefaults.standard.value(forKey: ACCESS_TOKEN) as! String
    let user_id = UserDefaults.standard.value(forKey: USER_ID) as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = OFAUtils.getColorFromHexString("f8f8f8")
        self.customizeTextFields()
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.saveProfilePressed))
        self.navigationItem.rightBarButtonItem = saveButton
        
        let singletonUser = OFA3SingletonUser.ofabeeUser
        self.textEmailAddress.text = singletonUser.user_email!
        self.textPhoneNumber.text = singletonUser.user_phone!
        self.textName.text = singletonUser.user_name!
        
        self.labelUserName.text = "Hi \(singletonUser.user_name!)!"
        
        self.imageViewProfile.layer.cornerRadius = self.imageViewProfile.frame.height/2
        self.imageViewProfile.sd_setImage(with: URL(string: singletonUser.user_imageURL!), placeholderImage: UIImage(named: "Default Image"), options: .refreshCached, context: nil)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        singleTap.numberOfTapsRequired = 1
        self.imageViewProfile.addGestureRecognizer(singleTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Edit Profile"
    }
    
    func customizeTextFields(){
        self.textName.lineColor = OFAUtils.getColorFromHexString(textFieldLineColor)
        self.textName.placeholderColor = OFAUtils.getColorFromHexString(textFieldPlaceHolderColor)
        
        self.textPhoneNumber.lineColor = OFAUtils.getColorFromHexString(textFieldLineColor)
        self.textPhoneNumber.placeholderColor = OFAUtils.getColorFromHexString(textFieldPlaceHolderColor)
        self.textPhoneNumber.textColor = OFAUtils.getColorFromHexString(textFieldPlaceHolderColor)
        
        self.textEmailAddress.lineColor = OFAUtils.getColorFromHexString(textFieldLineColor)
        self.textEmailAddress.placeholderColor = OFAUtils.getColorFromHexString(textFieldPlaceHolderColor)
        self.textEmailAddress.textColor = OFAUtils.getColorFromHexString(textFieldPlaceHolderColor)
    }
    
    @objc func imageTapped(){
        self.imagePicker.delegate = self
        actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default, handler: { (alert:UIAlertAction) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
                let cameraAlert = UIAlertController ( title:  NSLocalizedString("Sorry", comment: ""), message: NSLocalizedString("Camera Unavailable", comment: ""), preferredStyle: UIAlertController.Style.alert)
                cameraAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.cancel, handler: { (alert:UIAlertAction) -> Void in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(cameraAlert, animated: true, completion: nil)
            }
            else {
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .camera
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Photo Library", comment: ""), style: .default, handler: { (alert:UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == false {
                let cameraAlert = UIAlertController ( title: NSLocalizedString("Sorry", comment: ""), message: NSLocalizedString("Gallery Unavailable", comment: ""), preferredStyle: UIAlertController.Style.alert)
                cameraAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.cancel, handler: { (alert:UIAlertAction) -> Void in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(cameraAlert, animated: true, completion: nil)
            }
            else {
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (alert:UIAlertAction) -> Void in
            self.view.endEditing(true)
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
        
        if !OFAUtils.isiPhone(){
            let popOVer = actionSheet.popoverPresentationController
            popOVer?.sourceRect = self.imageViewProfile.bounds
            popOVer?.sourceView = self.imageViewProfile
        }
    }
    
    //MARK:- ImagePicker Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
//                pickedImage = (info[UIImagePickerControllerEditedImage] as? UIImage)!
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let photoURL = NSURL(fileURLWithPath: documentDirectory)
        let localPath = photoURL.appendingPathComponent("ProfileImage/\(self.user_id)")
        pickedImage = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage)!
        let resizeImage = OFAUtils.resizeImage(pickedImage, newWidth: 350)
        self.imageData = resizeImage.jpegData(compressionQuality: 1.0)
        do
        {
            try self.imageData?.write(to: localPath!, options: Data.WritingOptions.atomic)
        }
        catch
        {
            // Catch exception here and act accordingly
        }
        self.imageViewProfile.image = resizeImage
        self.tableView.reloadData()
        print(localPath!)
        self.uploadImage(fileURL: localPath!)
        dismiss(animated: true, completion: nil)
    }

    //MARK:- Image upload Helper
    
    func uploadImage(fileURL:URL){
        Alamofire.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(self.imageData!, withName: "file", fileName: "swift_file.jpeg", mimeType: "image/jpeg")},
                         usingThreshold:UInt64.init(),
                         to:userBaseURL+"upload_user_image",
                         method:.post,
                         headers:["Authorization": "Bearer \(self.accessToken)"],
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    debugPrint(response.result.value!)
                                    if let dicResponse = response.result.value as? NSDictionary{
                                        if let dicResponseMetaData = dicResponse["metadata"] as? NSDictionary{
                                            if "\(dicResponseMetaData["status_code"]!)" != "200"{
                                                OFAUtils.showToastWithTitle("\(dicResponseMetaData["message"]!)")
                                                return
                                            }else{
                                                OFAUtils.showToastWithTitle("\(dicResponseMetaData["message"]!)")
                                            }
                                        }
                                        if let dicUploadData = dicResponse["data"] as? NSDictionary{
                                            print(dicUploadData)
                                            OFA3SingletonUser.ofabeeUser.user_imageURL = "\(dicUploadData["upload_image"]!)"
                                            let coreDataManager = OFA3CoreDataManager()
                                            coreDataManager.saveUserImage(key: "user_image", value: "\(dicUploadData["upload_image"]!)")
                                            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "EditProfileImageNotification"), object: nil)
                                            self.navigationController?.popViewController(animated: true)
                                        }
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                OFAUtils.showAlertViewControllerWithinViewControllerWithTitle(viewController: self, alertTitle: nil, message: encodingError.localizedDescription, cancelButtonTitle: "OK")
                            }
        })
    }
    
    //MARK:- API for save user name
    
    @objc func saveProfilePressed(){
        let dicParameter = NSDictionary(objects: [self.textName.text!], forKeys: ["name" as NSCopying])
        let dicHeader = NSDictionary(objects: ["Bearer \(self.accessToken)"], forKeys: ["Authorization" as NSCopying])
        OFAUtils.showLoadingViewWithTitle(nil)
        Alamofire.request(userBaseURL+"edit_profile", method: .post, parameters: dicParameter as? Parameters, encoding: JSONEncoding.default, headers: dicHeader as? HTTPHeaders).responseJSON { (responseJSON) in
            if let dicResponse = responseJSON.result.value as? NSDictionary{
                OFAUtils.removeLoadingView(nil)
                if let dicResponseMetaData = dicResponse["metadata"] as? NSDictionary{
                    if "\(dicResponseMetaData["status_code"]!)" != "200"{
                        OFAUtils.showToastWithTitle("\(dicResponseMetaData["message"]!)")
                        return
                    }
                }
                if let dicProfileDetails = dicResponse["data"] as? NSDictionary{
                    print(dicProfileDetails)
                   OFA3SingletonUser.ofabeeUser.user_name = self.textName.text!
                    let coreDataManager = OFA3CoreDataManager()
                    coreDataManager.saveUserData(key: "user_name", value: self.textName.text!)
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                OFAUtils.removeLoadingView(nil)
                OFAUtils.showAlertViewControllerWithinViewControllerWithTitle(viewController: self, alertTitle: nil, message: responseJSON.error?.localizedDescription, cancelButtonTitle: "OK")
            }
        }
    }
    
    //MARK:- TableView delegates
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    //MARK:- TweeTextField Delegates
    
    @IBAction private func tweeTextFieldDidEndEditing(_ sender: TweeAttributedTextField) {
        switch sender {
        case self.textName:
            if OFAUtils.isWhiteSpace(self.textName.text!){
                self.textName.showInfo("Enter \(sender.tweePlaceholder!)")
            }
        case self.textPhoneNumber:
            if OFAUtils.isWhiteSpace(self.textPhoneNumber.text!){
                self.textPhoneNumber.showInfo("Enter \(sender.tweePlaceholder!)")
            }
        case self.textEmailAddress:
            if !OFAUtils.checkEmailValidation(self.textEmailAddress.text!){
                self.textEmailAddress.showInfo("Invalid \(sender.tweePlaceholder!)")
            }else{
                self.textEmailAddress.hideInfo()
            }
        default:
            print("invalid textfield")
        }
    }
    
    @IBAction private func tweeTextFieldDidBeginEditing(_ sender: TweeAttributedTextField) {
        switch sender {
        case self.textPhoneNumber:
            self.textPhoneNumber.hideInfo(animated: true)
        case self.textEmailAddress:
            self.textEmailAddress.hideInfo(animated: true)
        case self.textName:
            self.textName.hideInfo(animated: true)
        default:
            print("Invalid")
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag+1
        let nextResponder = textField.superview?.superview?.superview?.viewWithTag(nextTag)
        if nextResponder != nil{
            nextResponder?.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 50
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
