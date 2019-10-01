//
//  OFA3CategorySelectionContainerViewController.swift
//  Ofabee3.0
//
//  Created by Enfin on 08/08/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit
import Alamofire

class OFA3CategorySelectionContainerViewController: UIViewController,categorySelectionDelegate {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var buttonSkipPage: UIButton!
    @IBOutlet weak var imageViewSkipArrow: UIImageView!
    
    var arraySelectedCategories = [String]()
    var accessToken = ""
    var isFromRegisterPage = false
    var isFromProfilePage = false
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.viewContainer.dropShadow()
        if let categoryList = self.children[0] as? OFA3CategoryListTableViewController{
            categoryList.delegate = self
        }
        if self.isFromRegisterPage{
            self.navigationItem.hidesBackButton = true
        }

        self.buttonSkipPage.isHidden = self.isFromProfilePage ? true : false
        self.imageViewSkipArrow.isHidden = self.isFromProfilePage ? true : false
        
    }
    
    //MARK:- Button Actions
    
    @IBAction func continuePressed(_ sender: UIButton) {
        if self.arraySelectedCategories.count <= 0{
            OFAUtils.showToastWithTitle("Please select atleast one category")
            return
        }
//        let dicHeader = NSDictionary(objects: ["Bearer \(self.accessToken ?? "")"], forKeys: ["Authorization" as NSCopying])
        var dicHeader = NSDictionary()
        if self.accessToken != ""{
            dicHeader = NSDictionary(objects: ["Bearer \(self.accessToken)"], forKeys: ["Authorization" as NSCopying])
        }else{
            dicHeader = NSDictionary()
        }
        let dicParameter = NSDictionary(objects: [self.arraySelectedCategories.joined(separator: ",")], forKeys: ["category_id" as NSCopying])
        OFAUtils.showLoadingViewWithTitle("Saving")
        Alamofire.request(userBaseURL+"save_categories", method: .post, parameters: dicParameter as? Parameters, encoding: JSONEncoding.default, headers: dicHeader as? HTTPHeaders).responseJSON { (responseJSON) in
            if let dicResponse = responseJSON.result.value as? NSDictionary{
                OFAUtils.removeLoadingView(nil)
                if let dicResponseMetaData = dicResponse["metadata"] as? NSDictionary{
                    if "\(dicResponseMetaData["status_code"]!)" != "200"{
                        OFAUtils.showAlertViewControllerWithinViewControllerWithTitle(viewController: self, alertTitle: "Warning", message: "\(dicResponseMetaData["message"]!)", cancelButtonTitle: "OK")
                        return
                    }
                }
                if let _ = dicResponse["data"] as? NSDictionary{
                    (UIApplication.shared.delegate as! AppDelegate).initializeHomePage()
//                    self.navigationController?.popToRootViewController(animated: true)
                }
            }else{
                OFAUtils.removeLoadingView(nil)
                OFAUtils.showAlertViewControllerWithinViewControllerWithTitle(viewController: self, alertTitle: "Warning", message: responseJSON.error?.localizedDescription, cancelButtonTitle: "OK")
            }
        }
    }
    
    @IBAction func skipPressed(_ sender: UIButton) {
//        self.navigationController?.popToRootViewController(animated: true)
        //redirect to HOme page
        if self.isFromRegisterPage{
            (UIApplication.shared.delegate as! AppDelegate).initializeHomePage()
        }else{
            let homePage = self.storyboard?.instantiateViewController(withIdentifier: "HomePageTVC") as! OFA3HomePageTableViewController
            self.navigationItem.title = ""
            self.navigationController?.pushViewController(homePage, animated: true)
        }
    }
    
    func didSelectCategories(arraySelectedCategories: [String]) {
        self.arraySelectedCategories = arraySelectedCategories
    }
}
