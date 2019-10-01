//
//  OFA3ForgetPasswordTableViewController.swift
//  Ofabee3.0
//
//  Created by Enfin on 26/08/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit
import TweeTextField
import Alamofire

class OFA3ForgetPasswordTableViewController: UITableViewController,UITextFieldDelegate {

    @IBOutlet weak var textEmail: TweeAttributedTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        OFAUtils.setBackgroundForTableView(tableView: self.tableView)
        self.textEmail.lineColor = OFAUtils.getColorFromHexString(textFieldLineColor)
        self.textEmail.placeholderColor = OFAUtils.getColorFromHexString(textFieldPlaceHolderColor)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    //MARK:- Button Actions
    
    @IBAction func continuePressed(_ sender: UIButton) {
        self.view.endEditing(true)
        if !OFAUtils.checkEmailValidation(self.textEmail.text!){
            self.textEmail.showInfo("Invalid email address")
            return
        }
    
        let dicParameters = NSDictionary(objects: [self.textEmail.text!], forKeys: ["email" as NSCopying])
        OFAUtils.showLoadingViewWithTitle("Loading")
        Alamofire.request(userBaseURL+"forgot_password", method: .post, parameters: dicParameters as? Parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { (responseJSON) in
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
                    let passwordResetPage = self.storyboard?.instantiateViewController(withIdentifier: "PasswordResetTVC") as! OFA3PasswordResetTableViewController
                    passwordResetPage.emailID = self.textEmail.text!
//                    passwordResetPage.isFromForgetPassword = true
                    self.navigationItem.title = ""
                    self.navigationController?.pushViewController(passwordResetPage, animated: false)
                }
            }else{
                OFAUtils.removeLoadingView(nil)
                OFAUtils.showAlertViewControllerWithTitle(nil, message: responseJSON.error?.localizedDescription, cancelButtonTitle: "OK")
            }
        }
    }
    
    @IBAction func createNowPressed(_ sender: UIButton) {
        let registerPage = self.storyboard?.instantiateViewController(withIdentifier: "RegisterTVC") as! OFA3RegisterTableViewController
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(registerPage, animated: false)
    }
    
    //MARK:- TweeTextField Delegates
    
    @IBAction private func tweeTextFieldDidEndEditing(_ sender: TweeAttributedTextField) {
        switch sender {

        case self.textEmail:
            if !OFAUtils.checkEmailValidation(self.textEmail.text!){
                self.textEmail.showInfo("Invalid \(sender.tweePlaceholder!)")
            }else{
                self.textEmail.hideInfo()
            }
        
        default:
            print("invalid textfield")
        }
    }
    
    @IBAction private func tweeTextFieldDidBeginEditing(_ sender: TweeAttributedTextField) {
        switch sender {
        case self.textEmail:
            self.textEmail.hideInfo(animated: true)
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
