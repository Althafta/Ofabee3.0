//
//  OFA3RegisterTableViewController.swift
//  Ofabee3.0
//
//  Created by Enfin on 18/07/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit
import TweeTextField
import Alamofire

class OFA3RegisterTableViewController: UITableViewController,UITextFieldDelegate {

    @IBOutlet weak var labelPhoneCode: UILabel!
    
    @IBOutlet weak var textName: TweeAttributedTextField!
    @IBOutlet weak var textPhone: TweeAttributedTextField!
    @IBOutlet weak var textEmail: TweeAttributedTextField!
    @IBOutlet weak var textPassword: TweeAttributedTextField!
    
    @IBOutlet weak var viewTextLineColor: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        OFAUtils.setBackgroundForTableView(tableView: self.tableView)
        self.viewTextLineColor.backgroundColor = OFAUtils.getColorFromHexString(textFieldLineColor)
        self.customizeTextFields()
        
        let phoneCodeTap = UITapGestureRecognizer(target: self, action: #selector(self.getCountryDetails))
        phoneCodeTap.numberOfTapsRequired = 1
        self.labelPhoneCode.addGestureRecognizer(phoneCodeTap)
        
        let singleTapOnView = UITapGestureRecognizer(target: self, action: #selector(self.keyBoardDismiss))
        singleTapOnView.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(singleTapOnView)
        
        let dicCurrentCountry = PCCPViewController.infoFromSimCardAndiOSSettings() as! NSDictionary
        self.labelPhoneCode.text = "+\(dicCurrentCountry["phone_code"]!)"
        
        self.textPhone.inputAccessoryView = OFAUtils.getDoneToolBarButton(tableView: self, target: #selector(self.keyBoardDismiss))
        
    }

    @objc func getCountryDetails(){
        let phoneCodeVC = PCCPViewController { (dicCountry) in
            let dicCountryDetails = dicCountry as! NSDictionary
            self.labelPhoneCode.text = "+\(dicCountryDetails["phone_code"]!)"
        }
        let phoneNav = UINavigationController(rootViewController: phoneCodeVC!)
        self.present(phoneNav, animated: true, completion: nil)
    }
    
    @objc func keyBoardDismiss(){
        self.view.endEditing(true)
    }
    
    func customizeTextFields(){
        self.textPhone.lineColor = UIColor.clear
        self.textPhone.placeholderColor = OFAUtils.getColorFromHexString(textFieldPlaceHolderColor)
        self.textPhone.activeLineColor = UIColor.clear
        
        self.textPassword.lineColor = OFAUtils.getColorFromHexString(textFieldLineColor)
        self.textPassword.placeholderColor = OFAUtils.getColorFromHexString(textFieldPlaceHolderColor)
        
        self.textEmail.lineColor = OFAUtils.getColorFromHexString(textFieldLineColor)
        self.textEmail.placeholderColor = OFAUtils.getColorFromHexString(textFieldPlaceHolderColor)
        
        self.textName.lineColor = OFAUtils.getColorFromHexString(textFieldLineColor)
        self.textName.placeholderColor = OFAUtils.getColorFromHexString(textFieldPlaceHolderColor)
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear//UIColor.white.withAlphaComponent(0.6)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //MARK:- Button Actions
    
    @IBAction func joinNowPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        if OFAUtils.isWhiteSpace(self.textName.text!){
            self.textName.showInfo("Enter Name")
            return
        }
        if OFAUtils.isWhiteSpace(self.textPhone.text!){
            self.textPhone.showInfo("Enter Phone Number")
            return
        }
        if !OFAUtils.checkEmailValidation(self.textEmail.text!){
            self.textEmail.showInfo("Enter a valid email")
            return
        }
        if OFAUtils.isWhiteSpace(self.textPassword.text!){
            self.textPassword.showInfo("Enter password")
            return
        }
        let dicParameters = NSDictionary(objects: [self.textName.text!,self.textPhone.text!,self.textEmail.text!,self.textPassword.text!,self.labelPhoneCode.text!], forKeys: ["name" as NSCopying,"phone" as NSCopying,"email" as NSCopying,"password" as NSCopying,"country_code" as NSCopying])
        OFAUtils.showLoadingViewWithTitle("Loading")
        Alamofire.request(userBaseURL+"signup", method: .post, parameters: dicParameters as? Parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { (responseJSON) in
            if let dicResult = responseJSON.result.value as? NSDictionary{
//                print(dicResult)
                OFAUtils.removeLoadingView(nil)
                if let dicResponseMetaData = dicResult["metadata"] as? NSDictionary{
                    print(dicResponseMetaData)
                    if "\(dicResponseMetaData["status_code"]!)" != "200"{
//                        OFAUtils.showToastWithTitle("\(dicResponseMetaData["message"]!)")
                        OFAUtils.showAlertViewControllerWithTitle(nil, message: "\(dicResponseMetaData["message"]!)", cancelButtonTitle: "OK")
                        return
                    }
                }
                if let dicResponseData = dicResult["data"] as? NSDictionary{
                    print(dicResponseData)
                    var userDetails = Dictionary<String,Any>()
                    userDetails["name"] = self.textName.text!
                    userDetails["phone"] = self.textPhone.text!
                    userDetails["email"] = self.textEmail.text!
                    userDetails["password"] = self.textPassword.text!
                    userDetails["country_code"] = self.labelPhoneCode.text!
                    
                    let otpPage = self.storyboard?.instantiateViewController(withIdentifier: "OTPPageTVC") as! OFA3OTPTableViewController
                    otpPage.phoneNumber = self.labelPhoneCode.text!+" "+self.textPhone.text!
                    otpPage.isFromForgetPassword = false
                    otpPage.userDetails = userDetails
                    self.navigationItem.title = ""
                    self.navigationController?.pushViewController(otpPage, animated: false)
                }
            }else{
                OFAUtils.removeLoadingView(nil)
                OFAUtils.showAlertViewControllerWithTitle(nil, message: responseJSON.error?.localizedDescription, cancelButtonTitle: "OK")
            }
        }
    }
    
    @IBAction func haveAnAccountPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func skipPagePressed(_ sender: UIButton) {
        let categorySelection = self.storyboard?.instantiateViewController(withIdentifier: "CategorySelectionContainerVC") as! OFA3CategorySelectionContainerViewController
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(categorySelection, animated: true)
    }
    
    //MARK:- TweeTextField Delegates
    
    @IBAction private func tweeTextFieldDidEndEditing(_ sender: TweeAttributedTextField) {
        switch sender {
        case self.textName:
            if OFAUtils.isWhiteSpace(self.textName.text!){
                self.textName.showInfo("Enter \(sender.tweePlaceholder!)")
            }
        case self.textPhone:
            self.viewTextLineColor.backgroundColor = OFAUtils.getColorFromHexString(textFieldLineColor)
            if OFAUtils.isWhiteSpace(self.textPhone.text!){
                self.textPhone.showInfo("Enter \(sender.tweePlaceholder!)")
            }
        case self.textEmail:
            if !OFAUtils.checkEmailValidation(self.textEmail.text!){
                self.textEmail.showInfo("Invalid \(sender.tweePlaceholder!)")
            }else{
                self.textEmail.hideInfo()
            }
        case self.textPassword:
            if OFAUtils.isWhiteSpace(self.textPassword.text!){
                self.textPassword.showInfo("Enter \(sender.tweePlaceholder!)")
            }else  if self.textPassword.text!.count < 6{
                self.textPassword.showInfo("Minimum 6 required")
            }
        default:
            print("invalid textfield")
        }
    }
    
    @IBAction private func tweeTextFieldDidBeginEditing(_ sender: TweeAttributedTextField) {
        switch sender {
        case self.textPhone:
             self.viewTextLineColor.backgroundColor = OFAUtils.getColorFromHexString("5FB850")
            self.textPhone.hideInfo(animated: true)
        case self.textEmail:
            self.textEmail.hideInfo(animated: true)
        case self.textPassword:
            self.textPassword.hideInfo(animated: true)
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
        let phoneNumberLength = 16
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        if textField == self.textPhone{
            return newString.length <= phoneNumberLength
        }else{
            return newString.length <= maxLength
        }
    }
}
