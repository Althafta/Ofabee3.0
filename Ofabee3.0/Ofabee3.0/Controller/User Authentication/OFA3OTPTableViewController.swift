//
//  OFA3OTPTableViewController.swift
//  Ofabee3.0
//
//  Created by Enfin on 26/08/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit
import TweeTextField
import Alamofire

class OFA3OTPTableViewController: UITableViewController,UITextFieldDelegate {

    @IBOutlet weak var textOTP: TweeAttributedTextField!
    @IBOutlet weak var butonResendOTP: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet weak var labelOTPTimer: UILabel!
    
    var isFromForgetPassword = false
    var emailID = ""
    var phoneNumber = ""
    
    var userDetails = Dictionary<String,Any>()
    
    var seconds = 60
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OFAUtils.setBackgroundForTableView(tableView: self.tableView)
        self.labelTitle.text = self.isFromForgetPassword ? "An OTP has been sent to your Email Address \(self.emailID)" : "An OTP has been sent to your Phone Number \(self.phoneNumber)"
        self.textOTP.inputAccessoryView = OFAUtils.getDoneToolBarButton(tableView: self, target: #selector(self.dismissKeyboard))
        
        self.textOTP.lineColor = OFAUtils.getColorFromHexString(textFieldLineColor)
        self.textOTP.placeholderColor = OFAUtils.getColorFromHexString(textFieldPlaceHolderColor)
        
        self.butonResendOTP.isHidden = true
        self.runTimer()
    }
    
    func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateLabel(){
        seconds -= 1
        self.labelOTPTimer.text = "\(seconds)" + " seconds left"
        if seconds <= 0 {
            timer.invalidate()
            self.textOTP.isEnabled = false
            self.textOTP.text = ""
            self.labelOTPTimer.isHidden = true
            self.butonResendOTP.isHidden = false
            self.buttonContinue.isHidden = false
        }
    }
    
    //MARK:- Button Actions
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @IBAction func resendOTPPressed(_ sender: Any) {
        var mode = ""
        mode = self.isFromForgetPassword ? "2" : "1"
        let dicParameters = self.isFromForgetPassword ? NSDictionary(objects: [self.emailID,mode], forKeys: ["email" as NSCopying,"mode" as NSCopying]) : NSDictionary(objects: ["\(self.userDetails["phone"]!)","\(self.userDetails["email"]!)",mode], forKeys: ["phone" as NSCopying,"email" as NSCopying,"mode" as NSCopying])
        OFAUtils.showLoadingViewWithTitle(nil)
        Alamofire.request(userBaseURL+"resend_otp", method: .post, parameters: dicParameters as? Parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { (responseJSON) in
            if let dicResult = responseJSON.result.value as? NSDictionary{
                OFAUtils.removeLoadingView(nil)
                print(dicResult)
                self.labelOTPTimer.isHidden = false
                self.butonResendOTP.isHidden = true
                self.textOTP.isEnabled = true
                self.seconds = 60
                self.runTimer()
            }else{
                OFAUtils.removeLoadingView(nil)
                OFAUtils.showAlertViewControllerWithTitle(nil, message: responseJSON.error?.localizedDescription, cancelButtonTitle: "OK")
            }
        }
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        self.view.endEditing(true)
        if OFAUtils.isWhiteSpace(self.textOTP.text!){
            self.textOTP.showInfo("Enter OTP")
            return
        }
        self.isFromForgetPassword ? self.verifyOTPForForgotPassword(mode: "2", identifier: "2", otp: self.textOTP.text!) : self.verifyOTPForRegister(mode: "1", identifier: "1", otp: self.textOTP.text!)
    }
    
    @IBAction func createNowPressed(_ sender: UIButton) {
        let registerPage = self.storyboard?.instantiateViewController(withIdentifier: "RegisterTVC") as! OFA3RegisterTableViewController
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(registerPage, animated: false)
    }
    
    //MARK:- OTP Verification helpers
    
    func verifyOTPForRegister(mode:String,identifier:String,otp:String){
        let dicParameters = NSDictionary(objects: ["\(self.userDetails["name"]!)","\(self.userDetails["phone"]!)","\(self.userDetails["email"]!)","\(self.userDetails["password"]!)",mode,identifier,otp,"\(self.userDetails["country_code"]!)"], forKeys: ["name" as NSCopying,"phone" as NSCopying,"email" as NSCopying,"password" as NSCopying,"mode" as NSCopying,"identifier" as NSCopying,"otp" as NSCopying,"country_code" as NSCopying])
        OFAUtils.showLoadingViewWithTitle("Loading")
        Alamofire.request(userBaseURL+"otp_verification", method: .post, parameters: dicParameters as? Parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { (responseJSON) in
            if let dicResult = responseJSON.result.value as? NSDictionary{
//                print(dicResult)
                OFAUtils.removeLoadingView(nil)
                if let dicResponseMetaData = dicResult["metadata"] as? NSDictionary{
                    if "\(dicResponseMetaData["status_code"]!)" != "200"{
//                        OFAUtils.showToastWithTitle("\(dicResponseMetaData["message"]!)")
                        OFAUtils.showAlertViewControllerWithTitle(nil, message: "\(dicResponseMetaData["message"]!)", cancelButtonTitle: "OK")
                        return
                    }
                }
                if let dicResponseData = dicResult["data"] as? NSDictionary{
                    print(dicResponseData)
                    let categorySelection = self.storyboard?.instantiateViewController(withIdentifier: "CategorySelectionContainerVC") as! OFA3CategorySelectionContainerViewController
                    categorySelection.isFromRegisterPage = true
                    categorySelection.accessToken = "\(dicResponseData["token"]!)"
                    UserDefaults.standard.set("\(dicResponseData["token"]!)", forKey: ACCESS_TOKEN)
                    self.navigationItem.title = ""
                    self.navigationController?.pushViewController(categorySelection, animated: true)
                }
            }else{
                OFAUtils.removeLoadingView(nil)
                OFAUtils.showAlertViewControllerWithTitle(nil, message: responseJSON.error?.localizedDescription, cancelButtonTitle: "OK")
            }
        }
    }
    
    func verifyOTPForForgotPassword(mode:String,identifier:String,otp:String){
        let dicParameters = NSDictionary(objects: [self.emailID,mode,identifier,otp], forKeys: ["email" as NSCopying,"mode" as NSCopying,"identifier" as NSCopying,"otp" as NSCopying])
        OFAUtils.showLoadingViewWithTitle("Loading")
        Alamofire.request(userBaseURL+"otp_verification", method: .post, parameters: dicParameters as? Parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { (responseJSON) in
            if let dicResult = responseJSON.result.value as? NSDictionary{
                print(dicResult)
                OFAUtils.removeLoadingView(nil)
                if let dicResponseMetaData = dicResult["metadata"] as? NSDictionary{
                    if "\(dicResponseMetaData["status_code"]!)" != "200"{
//                        OFAUtils.showToastWithTitle("\(dicResponseMetaData["message"]!)")
                        OFAUtils.showAlertViewControllerWithTitle(nil, message: "\(dicResponseMetaData["message"]!)", cancelButtonTitle: "OK")
                        return
                    }
                }
                if let dicResponseData = dicResult["data"] as? NSDictionary{
                    print(dicResponseData)
                    OFAUtils.removeLoadingView(nil)
                    self.navigationController?.popToRootViewController(animated: true)
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
            
        default:
            print("invalid textfield")
        }
    }
    
    @IBAction private func tweeTextFieldDidBeginEditing(_ sender: TweeAttributedTextField) {
        switch sender {
        case self.textOTP:
            self.textOTP.hideInfo(animated: true)
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
}
