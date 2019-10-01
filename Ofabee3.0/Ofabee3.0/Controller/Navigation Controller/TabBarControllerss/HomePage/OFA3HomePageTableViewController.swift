//
//  OFA3HomePageTableViewController.swift
//  Ofabee3.0
//
//  Created by Enfin on 22/08/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit
import Alamofire

class OFA3HomePageTableViewController: UITableViewController,HomePopularCourseDelegate,HomeFeaturedCourseDelegate {

    var arrayHomeCourses = NSMutableArray()
    @IBOutlet var viewEmptyMessageHeader: UIView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var labelSectionTitle: UILabel!
    @IBOutlet weak var buttonSeeAll: UIButton!
    @IBOutlet weak var buttonRegisterSignIn: UIButton!
    @IBOutlet var viewFooter: UIView!
    
    var popularCourseArrayCount = 0
    var refreshController = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = OFAUtils.getColorFromHexString("F8F8F8")
        self.refreshController.tintColor = OFAUtils.getColorFromHexString(barTintColor)
        self.refreshController.addTarget(self, action: #selector(self.refreshInitiated), for: .valueChanged)
        self.tableView.addSubview(self.refreshController)
        
        let attributeRegisterString: NSMutableAttributedString =  NSMutableAttributedString(string: "Register ")
        attributeRegisterString.addAttribute(NSAttributedString.Key.foregroundColor, value: OFAUtils.getColorFromHexString("34a1f2"), range: NSMakeRange(0, attributeRegisterString.length))
        
        let attributeOrString: NSMutableAttributedString =  NSMutableAttributedString(string: "Or ")
        attributeOrString.addAttribute(NSAttributedString.Key.foregroundColor, value: OFAUtils.getColorFromHexString("c2c2c2"), range: NSMakeRange(0, attributeOrString.length))
        
        let attributeSignInString: NSMutableAttributedString =  NSMutableAttributedString(string: "Sign in ")
        attributeSignInString.addAttribute(NSAttributedString.Key.foregroundColor, value: OFAUtils.getColorFromHexString("34a1f2"), range: NSMakeRange(0, attributeSignInString.length))
        
        let attributeNowString: NSMutableAttributedString =  NSMutableAttributedString(string: "Now")
        attributeNowString.addAttribute(NSAttributedString.Key.foregroundColor, value: OFAUtils.getColorFromHexString("c2c2c2"), range: NSMakeRange(0, attributeNowString.length))
        
        let combinedString = NSMutableAttributedString()
        combinedString.append(attributeRegisterString)
        combinedString.append(attributeOrString)
        combinedString.append(attributeSignInString)
        combinedString.append(attributeNowString)
        self.buttonRegisterSignIn.setAttributedTitle(combinedString, for: .normal)//"\(attributeRegisterString) \(attributeOrString) \(attributeSignInString) \(attributeNowString)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.value(forKey: USER_ID) == nil{
//            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.barTintColor = OFAUtils.getColorFromHexString(barTintColor)
            self.navigationController?.navigationBar.isTranslucent=false
            self.navigationController?.view.backgroundColor = OFAUtils.getColorFromHexString(barTintColor)
            self.navigationController?.navigationBar.tintColor = .white
            self.getCourses(searchItem: "", categoryIds: "")
        }else{
//            if OFA3SingletonUser.ofabeeUser.user_category_id != nil{
//                self.getCourses(searchItem: "", categoryIds: OFA3SingletonUser.ofabeeUser.user_category_id!)
//            }
            self.refreshInitiated()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if UserDefaults.standard.value(forKey: USER_ID) == nil{
            self.setNavigationBarBeforeLogin()
        }
    }
    
    @objc func refreshInitiated(){
        self.getCourses(searchItem: "", categoryIds: "")
    }

    //MARK:- API for Home Page
    
    func getCourses(searchItem:String,categoryIds:String){
        var dicHeader = NSDictionary()
        if let accesToken = UserDefaults.standard.value(forKey: ACCESS_TOKEN) as? String{
            dicHeader = NSDictionary(objects: ["Bearer \(accesToken)"], forKeys: ["Authorization" as NSCopying])
        }else{
            dicHeader = NSDictionary()
        }
        let dicParameters = NSDictionary(objects: [searchItem,categoryIds], forKeys: ["search_item" as NSCopying,"category_ids" as NSCopying])
        Alamofire.request(userBaseURL+"home", method: .post, parameters: dicParameters as? Parameters, encoding: JSONEncoding.default, headers: dicHeader as? HTTPHeaders).responseJSON { (responseJSON) in
            if let dicResponse = responseJSON.result.value as? NSDictionary{
                if let dicResponseMetaData = dicResponse["metadata"] as? NSDictionary{
                    if "\(dicResponseMetaData["status_code"]!)" != "200"{
                        self.refreshController.endRefreshing()
                        OFAUtils.showToastWithTitle("\(dicResponseMetaData["message"]!)")
                        return
                    }
                }
                if let dicHomeCourseData = dicResponse["data"] as? NSDictionary{
                    let arrayHomeCourseList = dicHomeCourseData["courses"] as! NSArray
                    self.arrayHomeCourses = arrayHomeCourseList.mutableCopy() as! NSMutableArray
//                    for item in arrayHomeCourseList{
//                        let dicSection = item as! NSDictionary
//                        if !self.arrayHomeCourses.contains(dicSection){
//                            self.arrayHomeCourses.add(dicSection)
//                        }
//                    }
                    if let dicBanners = dicHomeCourseData["banners"] as? NSDictionary{
                        let arrayList = dicBanners["list"] as! NSArray
                        for item in arrayList{
                            let dicItem = item as! NSDictionary
                            arrayPreviewImages.append("\(dicItem["mb_title"]!)")
                        }
                        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "HomePageRefreshNotification"), object: nil)
                    }
                }
                if self.arrayHomeCourses.count > 0{
                    let arrayPopularCourse = self.getCourseList(for: 0)
                    if arrayPopularCourse!.count <= 5{
                        self.popularCourseArrayCount = arrayPopularCourse!.count
                    }else{
                        self.popularCourseArrayCount = 5
                    }
                }
                self.refreshController.endRefreshing()
                self.tableView.reloadData()
            }else{
                self.refreshController.endRefreshing()
                OFAUtils.showAlertViewControllerWithTitle(nil, message: responseJSON.error?.localizedDescription, cancelButtonTitle: "OK")
            }
        }
    }
    
    func getCourseList(for section:Int) -> NSArray?{
        if let dicSection = self.arrayHomeCourses[section] as? NSDictionary{
            if let arrayList = dicSection["list"] as? NSArray{
                return arrayList
            }
        }
        return nil
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayHomeCourses.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//self.getCourseList(for: section)!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomePopularCourseCell", for: indexPath) as! OFA3HomePopularCoursesTableViewCell
            cell.delegate = self
            cell.tableViewPopularCourses.backgroundColor = OFAUtils.getColorFromHexString(sectionBackgroundColor)
            cell.arrayPopularCourses = self.getCourseList(for: indexPath.section)!.mutableCopy() as! NSMutableArray
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeFeaturedCoursesCell", for: indexPath) as! OFA3HomeFeaturedCoursesTableViewCell
            cell.delegate = self
            cell.collectionViewFeaturedCourses.backgroundColor = OFAUtils.getColorFromHexString(sectionBackgroundColor)
            cell.arrayFeaturedCourses = self.getCourseList(for: indexPath.section)?.mutableCopy() as! NSMutableArray
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dicSection = self.arrayHomeCourses[section] as! NSDictionary
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60))
        
        let labelTitle = UILabel()
        labelTitle.frame = CGRect.init(x: 16, y: 22, width: 150, height: 24)
        labelTitle.text = "\(dicSection["title"]!)"
        labelTitle.font = UIFont(name: "OpenSans-Bold", size: 17.0) // my custom font
        labelTitle.textColor = UIColor.black // my custom colour
        
        let buttonSeeAll = UIButton()
        buttonSeeAll.frame = CGRect(x: self.tableView.frame.width - 70, y: 18, width: 60, height: 33)
        buttonSeeAll.setTitle("See all", for: .normal)
        buttonSeeAll.setTitleColor(OFAUtils.getColorFromHexString("737373"), for: .normal)
        buttonSeeAll.titleLabel?.font = UIFont(name: "OpenSans-Regular", size: 15.0)
        buttonSeeAll.addTarget(self, action: #selector(self.seeAllPressedFromHeader(button:)), for: .touchUpInside)
        buttonSeeAll.tag = section
        
        headerView.addSubview(labelTitle)
        headerView.addSubview(buttonSeeAll)
        headerView.backgroundColor = OFAUtils.getColorFromHexString(sectionBackgroundColor)
        
        return headerView
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let dicSection = self.arrayHomeCourses[section] as! NSDictionary
//        return "\(dicSection["title"]!)"
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if UIScreen.main.bounds.height <= 735{
                return CGFloat(self.popularCourseArrayCount*100)
            }else{
                return CGFloat(self.popularCourseArrayCount*125)
            }
        }else if indexPath.section == 1{
            return 180
        }else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = OFAUtils.getColorFromHexString(sectionBackgroundColor)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return !OFAUtils.isiPhone() ? 50 : 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1{
            if (UserDefaults.standard.value(forKey: USER_ID) as? String) == nil{
                return self.viewFooter
            }else{
                return nil
            }
        }else{
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1{
            if OFA3SingletonUser.ofabeeUser.user_id == nil{
                return 103
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    //MARK:- Home Popular Course Delegate
    
    func getArrayPopularCourseDetails(array: NSArray) {
        if array.count <= 5{
            self.popularCourseArrayCount = array.count
        }else{
            self.popularCourseArrayCount = 5
        }
        self.tableView.reloadData()
    }
    
    func pushToNextPageFromPopularCourse(childVewController: UIViewController) {
//        OFAUtils.showAlertViewControllerWithinViewControllerWithTitle(viewController: self, alertTitle: nil, message: "Please contact Administrator to access this course", cancelButtonTitle: "OK")
        self.present(childVewController, animated: true, completion: nil)
    }
    
    //MARK:- Home Feature Course Delegate
    
    func getArrayFeatureCourseDetails(array: NSArray) {
        
    }
    
    func pushToNextPageFromFeatureCourse(childVewController: UIViewController) {
//        OFAUtils.showAlertViewControllerWithinViewControllerWithTitle(viewController: self, alertTitle: nil, message: "Please contact Administrator to access this course", cancelButtonTitle: "OK")
        self.present(childVewController, animated: true, completion: nil)
    }
    
    //MARK:- Button Actions
    
    @IBAction func registerOrSignInPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func seeAllPressedFromHeader(button:UIButton){
        let allCourseList = self.storyboard?.instantiateViewController(withIdentifier: "AllCoursesListTVC") as! OFA3AllCoursesListTableViewController
        if button.tag == 0{
            allCourseList.listIdentifier = "1"
        }else{
            allCourseList.listIdentifier = "2"
        }
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(allCourseList, animated: true)
        //                self.tabBarController?.navigationController?.pushViewController(allCourseList, animated: true)
    }
    
    @IBAction func seeAllPressed(_ sender: UIButton) {
        
    }
    
}
