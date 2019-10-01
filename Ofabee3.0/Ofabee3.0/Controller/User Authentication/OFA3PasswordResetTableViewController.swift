//
//  OFA3PasswordResetTableViewController.swift
//  Ofabee3.0
//
//  Created by Enfin on 19/09/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit
import TweeTextField
import Alamofire

class OFA3PasswordResetTableViewController: UITableViewController {

    @IBOutlet weak var textNewPassword: TweeAttributedTextField!
    @IBOutlet weak var textOTP: TweeAttributedTextField!
    @IBOutlet weak var labelOTPMessage: UILabel!
    
    var emailID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelOTPMessage.text = "An OTP has been sent to your Email Address \(self.emailID)"
        self.customizeTextFields()
    }

    func customizeTextFields(){
        self.textNewPassword.lineColor = OFAUtils.getColorFromHexString(textFieldLineColor)
        self.textNewPassword.placeholderColor = OFAUtils.getColorFromHexString(textFieldPlaceHolderColor)
        
        self.textOTP.lineColor = OFAUtils.getColorFromHexString(textFieldLineColor)
        self.textOTP.placeholderColor = OFAUtils.getColorFromHexString(textFieldPlaceHolderColor)
    }
    
    // MARK: - API Helper
    
    func verifyOTPForForgotPassword(mode:String,identifier:String,otp:String,password:String){
        let dicParameters = NSDictionary(objects: [self.emailID,mode,identifier,otp,password], forKeys: ["email" as NSCopying,"mode" as NSCopying,"identifier" as NSCopying,"otp" as NSCopying,"password" as NSCopying])
        OFAUtils.showLoadingViewWithTitle("Loading")
        Alamofire.request(userBaseURL+"otp_verification", method: .post, parameters: dicParameters as? Parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { (responseJSON) in
            if let dicResult = responseJSON.result.value as? NSDictionary{
                OFAUtils.removeLoadingView(nil)
                if let dicResponseMetaData = dicResult["metadata"] as? NSDictionary{
                    if "\(dicResponseMetaData["status_code"]!)" != "200"{
                        OFAUtils.showAlertViewControllerWithTitle(nil, message: "\(dicResponseMetaData["message"]!)", cancelButtonTitle: "OK")
                        return
                    }
                }
                if let _ = dicResult["data"] as? NSDictionary{
                    OFAUtils.removeLoadingView(nil)
                    self.navigationController?.popToRootViewController(animated: true)
                    OFAUtils.showToastWithTitle("Password updated successfully")
                }
            }else{
                OFAUtils.removeLoadingView(nil)
                OFAUtils.showAlertViewControllerWithTitle(nil, message: responseJSON.error?.localizedDescription, cancelButtonTitle: "OK")
            }
        }
    }
    
    //MARK:- TweeTextField Delegates
    
    @IBAction private func tweeTextFieldDidEndEditing(_ sender: TweeAttributedTextField) {
        switch sender {
            
        case self.textOTP:
            if OFAUtils.isWhiteSpace(self.textOTP.text!){
                self.textOTP.showInfo("Enter \(sender.tweePlaceholder!)")
            }else{
                self.textOTP.hideInfo()
            }
        case self.textNewPassword:
            if OFAUtils.isWhiteSpace(self.textNewPassword.text!){
                self.textNewPassword.showInfo("Enter \(sender.tweePlaceholder!)")
            }else  if self.textNewPassword.text!.count < 6{
                self.textNewPassword.showInfo("Minimum 6 required")
            }else{
                self.textNewPassword.hideInfo()
            }
            
        default:
            print("invalid textfield")
        }
    }
    
    @IBAction private func tweeTextFieldDidBeginEditing(_ sender: TweeAttributedTextField) {
        switch sender {
        case self.textOTP:
            self.textOTP.hideInfo(animated: true)
        case self.textNewPassword:
            self.textNewPassword.hideInfo(animated: true)
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
        let maxLength = 5
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

    //MARK:- Button Actions
    
    @IBAction func continuePressed(_ sender: UIButton) {
        self.view.endEditing(true)
        if OFAUtils.isWhiteSpace(self.textNewPassword.text!){
            self.textNewPassword.showInfo("Enter New Password")
            return
        }
        if self.textNewPassword.text!.count < 6{
            self.textNewPassword.showInfo("Minimum 6 required")
            return
        }
        if OFAUtils.isWhiteSpace(self.textOTP.text!){
            self.textOTP.showInfo("Invalid email address")
            return
        }
        self.verifyOTPForForgotPassword(mode: "2", identifier: "2", otp: self.textOTP.text!, password: self.textNewPassword.text!)
    }
}
