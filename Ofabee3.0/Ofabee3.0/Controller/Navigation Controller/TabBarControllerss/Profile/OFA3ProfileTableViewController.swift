//
//  OFA3SettingsTableViewController.swift
//  Ofabee3.0
//
//  Created by Enfin on 04/09/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class OFA3ProfileTableViewController: UITableViewController {

    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelRewardPoints: UILabel!
    
    @IBOutlet var viewFooter: UIView!
    @IBOutlet weak var buttonSignOut: UIButton!
    
    let accessToken = UserDefaults.standard.value(forKey: ACCESS_TOKEN) as! String
    var arraySettingsMenu = ["Edit Profile","Change Category","Notification","Support","Privacy Policy","Terms of use","Share Ofabee"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = OFAUtils.getColorFromHexString("f8f8f8")
        self.viewFooter.backgroundColor = OFAUtils.getColorFromHexString("f8f8f8")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "My Account"
        
        let singletonUser = OFA3SingletonUser.ofabeeUser
        self.imageViewProfile.layer.cornerRadius = self.imageViewProfile.frame.height/2
        if OFA3SingletonUser.ofabeeUser.user_imageURL != nil{
            self.imageViewProfile.sd_setImage(with: URL(string: OFA3SingletonUser.ofabeeUser.user_imageURL!), placeholderImage: UIImage(named: "EmptyProfilePlaceHolder"), options: .progressiveLoad, context: nil)
            self.labelUserName.text = "Hi \(singletonUser.user_name!)!"
        }
        self.getProfileDetails()
    }

    //MARK:- API Handlers
    
    func getProfileDetails(){
        let dicHeader = NSDictionary(objects: ["Bearer \(self.accessToken)"], forKeys: ["Authorization" as NSCopying])
        print(dicHeader)
        Alamofire.request(userBaseURL+"profile", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: dicHeader as? HTTPHeaders).responseJSON { (responseJSON) in
            if let dicResponse = responseJSON.result.value as? NSDictionary{
                print(dicResponse)
                if let dicResponseMetaData = dicResponse["metadata"] as? NSDictionary{
                    if "\(dicResponseMetaData["status_code"]!)" != "200"{
                        OFAUtils.showToastWithTitle("\(dicResponseMetaData["message"]!)")
                        return
                    }
                }
                if let dicProfileDetails = dicResponse["data"] as? NSDictionary{
                    self.labelUserName.text = "Hi \(dicProfileDetails["us_name"]!)!"
                    self.imageViewProfile.sd_setImage(with: URL(string: "\(dicProfileDetails["us_image"]!)"), placeholderImage: UIImage(named: "EmptyProfilePlaceHolder"), options: .progressiveLoad, context: nil)
                    let attributedString1 = NSAttributedString(string: "Reward Points ", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
                    let mutableAttributedString = NSMutableAttributedString()
                    mutableAttributedString.append(attributedString1)
                    var font = UIFont()
                    if UIFont(name: "OpenSans-Bold", size: 20.0) != nil{
                        font = UIFont(name: "OpenSans-Bold", size: 20.0)!
                    }else{
                        font = UIFont.boldSystemFont(ofSize: 20.0)
                    }
                    mutableAttributedString.append(NSAttributedString(string: "\(dicProfileDetails["score"]!)", attributes: [NSAttributedString.Key.foregroundColor:OFAUtils.getColorFromHexString("00ffde"),NSAttributedString.Key.font:font]))
                    self.labelRewardPoints.attributedText = mutableAttributedString
                    OFA3SingletonUser.ofabeeUser.user_name = "\(dicProfileDetails["us_name"]!)"
                    OFA3SingletonUser.ofabeeUser.user_imageURL = "\(dicProfileDetails["us_image"]!)"
                    OFA3SingletonUser.ofabeeUser.user_category_id = "\(dicProfileDetails["us_category_id"]!)"
                    OFA3SingletonUser.ofabeeUser.user_email = "\(dicProfileDetails["us_email"]!)"
                    OFA3SingletonUser.ofabeeUser.user_phone = "\(dicProfileDetails["us_phone"]!)"
                    let coreDataManager = OFA3CoreDataManager()
                    
                    
                }
            }else{
                if responseJSON.response?.statusCode == 500{
                    
                }else{
                    OFAUtils.showAlertViewControllerWithTitle(nil, message: responseJSON.error?.localizedDescription, cancelButtonTitle: "OK")
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arraySettingsMenu.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! OFA3ProfileSettingsTableViewCell

        cell.labelSettingsMenu.text = self.arraySettingsMenu[indexPath.row]
        if indexPath.row == 2{
            cell.switchButton.isHidden = false
            cell.isSelected = false
        }else{
            cell.switchButton.isHidden = true
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! OFA3ProfileSettingsTableViewCell
        if indexPath.row == 0{
            let editProfilePage = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileTVC") as! OFA3EditProfileTableViewController
            self.tabBarController?.navigationItem.title = ""
            self.navigationController?.pushViewController(editProfilePage, animated: true)
        }else if indexPath.row == 1{
            let categoryPage = self.storyboard?.instantiateViewController(withIdentifier: "CategorySelectionContainerVC") as! OFA3CategorySelectionContainerViewController
            categoryPage.isFromProfilePage = true
            self.tabBarController?.navigationItem.title = ""
            self.navigationController?.pushViewController(categoryPage, animated: true)
        }else if indexPath.row == 4{
            let webViewRedirect = self.storyboard?.instantiateViewController(withIdentifier: "WebViewReDirectionVC") as! OFA3WebViewReDirectionViewController
            webViewRedirect.reDirectURL = "https://testing-neyyar.enfinlabs.com/privacy-policy"
            webViewRedirect.pageTitle = "Privacy Policy"
            self.tabBarController?.navigationItem.title = ""
            self.navigationController?.pushViewController(webViewRedirect, animated: true)
        }else if indexPath.row == 5{
            let webViewRedirect = self.storyboard?.instantiateViewController(withIdentifier: "WebViewReDirectionVC") as! OFA3WebViewReDirectionViewController
            webViewRedirect.reDirectURL = "https://testing-neyyar.enfinlabs.com/terms-and-condition"
            webViewRedirect.pageTitle = "Terms of use"
            self.tabBarController?.navigationItem.title = ""
            self.navigationController?.pushViewController(webViewRedirect, animated: true)
        }else if indexPath.row == 6{
            let shareText = "Hi Ofabee 3.0 "
            let shareOfabeeActivityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
            shareOfabeeActivityVC.popoverPresentationController?.sourceView = cell
            self.present(shareOfabeeActivityVC, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear//OFAUtils.getColorFromHexString("f8f8f8")
    }
    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return self.viewFooter
//    }
//
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 74
//    }
    
    //MARK:- Button Actions
    
    @IBAction func signOutPressed(_ sender: UIButton) {
        let logoutAlert = UIAlertController(title: nil, message: "Are you sure to signout?", preferredStyle: .alert)
        logoutAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alertAction) in
            self.logout()
        }))
        logoutAlert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { (alertAction) in
            
        }))
        self.present(logoutAlert, animated: true, completion: nil)
    }
    
    func logout(){
        (UIApplication.shared.delegate as! AppDelegate).logout()
    }
    
    @IBAction func buttonPressed(_ sender: UISwitch) {
        sender.isSelected = !sender.isSelected
    }
}
