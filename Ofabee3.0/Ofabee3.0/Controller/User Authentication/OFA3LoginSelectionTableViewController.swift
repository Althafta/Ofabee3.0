//
//  OFA3LoginSelectionTableViewController.swift
//  Ofabee3.0
//
//  Created by Enfin on 16/07/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit
import TweeTextField
import Alamofire

class OFA3LoginSelectionTableViewController: UITableViewController,UITextFieldDelegate {

//    @IBOutlet weak var segmentControlPhoneEmail: TabySegmentedControl!
    @IBOutlet weak var textPhone: TweeAttributedTextField!
    @IBOutlet weak var textEmailAddress: TweeAttributedTextField!
    @IBOutlet weak var textPassword: TweeAttributedTextField!
    @IBOutlet weak var labelPhoneCode: UILabel!
    @IBOutlet weak var buttonForgetPassword: UIButton!
    @IBOutlet weak var buttonPhoneNumber: UIButton!
    @IBOutlet weak var buttonEmailAddress: UIButton!
    
    @IBOutlet weak var viewTextLineColor: UIView!
    
    var selectedLoginOption = 0
    
    var arrayIndicesForEmail = [4]
    
    //MARK:- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.segmentControlPhoneEmail.initUI()
        OFAUtils.setBackgroundForTableView(tableView: self.tableView)
        self.customizeTextFields()
        
        self.viewTextLineColor.backgroundColor = OFAUtils.getColorFromHexString(textFieldLineColor)
        if self.selectedLoginOption == 0{
            self.buttonPhoneNumber.setTitleColor(OFAUtils.getColorFromHexString("33B565"), for: .normal)
            self.buttonEmailAddress.setTitleColor(OFAUtils.getColorFromHexString("A9A9A9"), for: .normal)
        }
        let phoneCodeTap = UITapGestureRecognizer(target: self, action: #selector(self.getCountryDetails))
        phoneCodeTap.numberOfTapsRequired = 1
        self.labelPhoneCode.addGestureRecognizer(phoneCodeTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getCountryPhoneCode), name: NSNotification.Name.init(rawValue: "CountryFetchedNotification"), object: nil)
        
        self.textPhone.inputAccessoryView = OFAUtils.getDoneToolBarButton(tableView: self, target: #selector(self.keyBoardDismiss))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.setNavigationBarBeforeLogin()
        self.resetTextFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func customizeTextFields(){
        self.textPhone.lineColor = UIColor.clear//OFAUtils.getColorFromHexString(textFieldLineColor)
        self.textPhone.placeholderColor = OFAUtils.getColorFromHexString(textFieldPlaceHolderColor)
        self.textPhone.activeLineColor = UIColor.clear
        self.textPhone.infoFontSize = 10.0
        
        self.textPassword.lineColor = OFAUtils.getColorFromHexString(textFieldLineColor)
        self.textPassword.placeholderColor = OFAUtils.getColorFromHexString(textFieldPlaceHolderColor)
        self.textPassword.infoFontSize = 10.0
        
        self.textEmailAddress.lineColor = OFAUtils.getColorFromHexString(textFieldLineColor)
        self.textEmailAddress.placeholderColor = OFAUtils.getColorFromHexString(textFieldPlaceHolderColor)
        self.textEmailAddress.infoFontSize = 10.0
    }
    
    @objc func getCountryPhoneCode(){
        let currentCountryCode = UserDefaults.standard.value(forKey: Country_Code) as? String
        if currentCountryCode != nil{
            let dicCurrentCountry = PCCPViewController.getCountryDetails(with: currentCountryCode) as! NSDictionary//PCCPViewController.infoFromSimCardAndiOSSettings() as! NSDictionary
            self.labelPhoneCode.text = "+\(dicCurrentCountry["phone_code"]!)"
        }
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
    //MARK:- TableView Delegates
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear//UIColor.white.withAlphaComponent(0.6)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedLoginOption == 0{
            if self.arrayIndicesForEmail.contains(indexPath.row){
                return 0
            }else{
                return 70
            }
        }else{
            if indexPath.row == 3{
                return 0
            }
            return 70
        }
    }
    
    func resetTextFields(){
        self.textPhone.text = ""
        self.textPhone.hideInfo()
        textPhone.infoAnimationDuration = 0.0
        
        self.textEmailAddress.text = ""
        self.textEmailAddress.hideInfo()
        textEmailAddress.infoAnimationDuration = 0.0
        
        self.textPassword.text = ""
        self.textPassword.hideInfo()
        textPassword.infoAnimationDuration = 0.0
    }
    
    //MARK:- Button Actions
    
    @IBAction func loginOptionSelected(_ sender: UIButton) {
        self.view.endEditing(true)
        self.resetTextFields()
        self.selectedLoginOption = sender.tag == 1 ? 0 : 1
        if sender.tag == 1{
            self.buttonPhoneNumber.setTitleColor(OFAUtils.getColorFromHexString("33B565"), for: .normal)
            self.buttonEmailAddress.setTitleColor(OFAUtils.getColorFromHexString("A9A9A9"), for: .normal)
        }else{
            self.buttonEmailAddress.setTitleColor(OFAUtils.getColorFromHexString("33B565"), for: .normal)
            self.buttonPhoneNumber.setTitleColor(OFAUtils.getColorFromHexString("A9A9A9"), for: .normal)
        }
        self.tableView.reloadData()
    }
    
    @IBAction func forgetPasswordPressed(_ sender: UIButton) {
        let forgetPasswordPage = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordTVC") as! OFA3ForgetPasswordTableViewController
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(forgetPasswordPage, animated: false)
    }
    
    @IBAction func segmentControlSelected(_ sender: TabySegmentedControl) {
        self.tableView.reloadData()
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        self.view.endEditing(true)
        var loginMode = ""
        if self.selectedLoginOption == 1{
            loginMode = "2"
            if !OFAUtils.checkEmailValidation(self.textEmailAddress.text!){
                self.textEmailAddress.showInfo("Invalid email address")
                return
            }
        }else{
            loginMode = "1"
            if !self.textPhone.text!.isNumber{
                self.textPhone.showInfo("Enter valid phone number")
                return
            }
        }
        if OFAUtils.isWhiteSpace(self.textPassword.text!){
            self.textPassword.showInfo("Enter your password")
            return
        }else if self.textPassword.text!.count < 6{
            self.textPassword.showInfo("Minimum 6 required")
        }else{
            self.signInAction(mode: loginMode)
        }
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        let registerPage = self.storyboard?.instantiateViewController(withIdentifier: "RegisterTVC") as! OFA3RegisterTableViewController
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(registerPage, animated: true)
    }
    
    @IBAction func skipPagePressed(_ sender: UIButton) {
        let categorySelection = self.storyboard?.instantiateViewController(withIdentifier: "CategorySelectionContainerVC") as! OFA3CategorySelectionContainerViewController
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(categorySelection, animated: true)
    }
    
    //MARK:- API Helpers
    
    func signInAction(mode:String){
        let dicParameters = NSDictionary(objects: [self.textPhone.text!,self.textEmailAddress.text!,mode,self.textPassword.text!], forKeys: ["phone" as NSCopying,"email" as NSCopying,"mode" as NSCopying,"password" as NSCopying])
        OFAUtils.showLoadingViewWithTitle("Loading")
        Alamofire.request(userBaseURL+"login", method: .post, parameters: dicParameters as? Parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { (responseJSON) in
            if let dicResponse = responseJSON.result.value as? NSDictionary{
                OFAUtils.removeLoadingView(nil)
                if let dicResponseMetaData = dicResponse["metadata"] as? NSDictionary{
                    if "\(dicResponseMetaData["status_code"]!)" != "200"{
                        OFAUtils.showAlertViewControllerWithTitle(nil, message: "\(dicResponseMetaData["message"]!)", cancelButtonTitle: "OK")
                        return
                    }
                }
                if let dicResponseData = dicResponse["data"] as? NSDictionary{
                    UserDefaults.standard.set("\(dicResponseData["token"]!)", forKey: ACCESS_TOKEN)
                    let dicUser = dicResponseData["user"] as! NSDictionary
                    UserDefaults.standard.set("\(dicUser["id"]!)", forKey: USER_ID)
                    self.updateUserModelWith(userDetails: dicUser)
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.initializeHomePage()
                }
            }else{
                OFAUtils.removeLoadingView(nil)
                OFAUtils.showAlertViewControllerWithTitle(nil, message: responseJSON.error?.localizedDescription, cancelButtonTitle: "OK")
            }
        }
    }
    
    func updateUserModelWith(userDetails:NSDictionary){
        
        let coreDataManager = OFA3CoreDataManager()
        coreDataManager.saveUserDetails(toCoreDataWith: userDetails)
        
        let ofabeeUser = OFA3SingletonUser()
        ofabeeUser.initWithDictionary(dicData: userDetails)
    }
    
    //MARK:- TweeTextField Delegates
    
    @IBAction private func tweeTextFieldDidEndEditing(_ sender: TweeAttributedTextField) {
        switch sender {
        case self.textPhone:
            self.viewTextLineColor.backgroundColor = OFAUtils.getColorFromHexString(textFieldLineColor)
            if !self.textPhone.text!.isNumber{
                self.textPhone.showInfo("Enter valid \(sender.tweePlaceholder!)")
            }
        case self.textEmailAddress:
            if !OFAUtils.checkEmailValidation(self.textEmailAddress.text!){
                self.textEmailAddress.showInfo("Invalid \(sender.tweePlaceholder!)")
            }else{
                self.textEmailAddress.hideInfo()
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
        case self.textEmailAddress:
            self.textEmailAddress.hideInfo(animated: true)
        case self.textPassword:
            self.textPassword.hideInfo(animated: true)
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
//        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
//        let filtered = currentString.components(separatedBy: cs).joined(separator: "")
//
//        if  filtered == ""{
//            return false
//        }
        
        if textField == self.textPhone{
            return newString.length <= phoneNumberLength
        }else{
            return newString.length <= maxLength
        }
//        return (string == filtered)
    }
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
