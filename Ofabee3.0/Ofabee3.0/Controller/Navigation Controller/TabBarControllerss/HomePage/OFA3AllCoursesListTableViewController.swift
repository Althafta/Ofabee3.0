//
//  OFA3AllCoursesListTableViewController.swift
//  Ofabee3.0
//
//  Created by Enfin on 23/09/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit
import Alamofire

class OFA3AllCoursesListTableViewController: UITableViewController {

    var arrayAllCoursesList = NSMutableArray()
    var refreshController = UIRefreshControl()
    
    var listIdentifier = "1"
    var offset = 0
    var limit = "6"
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshController.tintColor = OFAUtils.getColorFromHexString(barTintColor)
        self.refreshController.addTarget(self, action: #selector(self.refreshInitiated), for: .valueChanged)
        self.tableView.addSubview(self.refreshController)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = self.listIdentifier == "1" ? "Popular Courses" : "Featured Courses"
        self.refreshInitiated()
    }
    
    @objc func refreshInitiated(){
        self.offset = 0
        self.index = 0
        self.getAllCourses(searchItem: "", categoryIds: "", identifier: self.listIdentifier, offset: "\(self.offset)", limit: "6")
    }
    
    func getAllCourses(searchItem:String,categoryIds:String,identifier:String,offset:String,limit:String){
        print("offset : \(offset)")
        print("limit : \(limit)")
        if self.index-1 >= self.arrayAllCoursesList.count{
            return
        }
        var dicHeader = NSDictionary()
        if let accesToken = UserDefaults.standard.value(forKey: ACCESS_TOKEN) as? String{
            dicHeader = NSDictionary(objects: ["Bearer \(accesToken)"], forKeys: ["Authorization" as NSCopying])
        }else{
            dicHeader = NSDictionary()
        }
        let dicParameters = NSDictionary(objects: [searchItem,categoryIds,identifier,offset,limit], forKeys: ["search_keyword" as NSCopying,"category_ids" as NSCopying,"identifier" as NSCopying,"offset" as NSCopying,"limit" as NSCopying])
        OFAUtils.showLoadingViewWithTitle(nil)
        Alamofire.request(userBaseURL+"more_items", method: .post, parameters: dicParameters as? Parameters, encoding: JSONEncoding.default, headers: dicHeader as? HTTPHeaders).responseJSON { (responseJSON) in
            if let dicResponse = responseJSON.result.value as? NSDictionary{
                OFAUtils.removeLoadingView(nil)
                self.refreshController.endRefreshing()
                if let dicResponseMetaData = dicResponse["metadata"] as? NSDictionary{
                    if "\(dicResponseMetaData["status_code"]!)" != "200"{
                        OFAUtils.showToastWithTitle("\(dicResponseMetaData["message"]!)")
                        return
                    }
                }
                if let dicReponseData = dicResponse["data"] as? NSDictionary{
                    let arrayCourses = dicReponseData["list"] as! NSArray
                    print(arrayCourses.count)
                    self.arrayAllCoursesList = arrayCourses.mutableCopy() as! NSMutableArray
                }
                self.tableView.reloadData()
            }else{
                OFAUtils.removeLoadingView(nil)
                self.refreshController.endRefreshing()
                OFAUtils.showAlertViewControllerWithinViewControllerWithTitle(viewController: self, alertTitle: nil, message: responseJSON.error?.localizedDescription, cancelButtonTitle: "OK")
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayAllCoursesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllCoursesListCell", for: indexPath) as! OFA3AllCoursesListTableViewCell
        
        let dicCourseDetails = self.arrayAllCoursesList[indexPath.row] as! NSDictionary
        var isBundle = false
        if "\(dicCourseDetails["item_type"]!)" == "bundle"{
            isBundle = true
        }else{
            isBundle = false
        }
        cell.customizeCellWithDetails(imageURL: "\(dicCourseDetails["item_image"]!)", courseTitle: "\(dicCourseDetails["item_name"]!)", categories: dicCourseDetails["item_category"] as! NSArray, ratingValue: "\(dicCourseDetails["item_rating"]!)", ratingCount: "\(dicCourseDetails["item_id"]!)", isBundle: isBundle, courseOriginalPrice: "\(dicCourseDetails["item_price"]!)", courseDiscountPrice: "\(dicCourseDetails["item_discount"]!)", freeStatus: "\(dicCourseDetails["item_is_free"]!)")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Warning", message: "Please contact Administrator to activate the course", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIScreen.main.bounds.height <= 735{
            return 95
        }else{
            return 120
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = OFAUtils.getColorFromHexString(sectionBackgroundColor)
        if indexPath.row  == self.arrayAllCoursesList.count-1 {
            self.index = index + 6
            self.offset += 1
            self.getAllCourses(searchItem: "", categoryIds: "", identifier: self.listIdentifier, offset: "\(self.offset)", limit: "6")
//            if self.user_id == nil {
////                self.loadCourses(with: "", userID: "", limit: "10", offset: Int(self.offset), token: "")
//                self.getAllCourses(searchItem: "", categoryIds: "", identifier: self.listIdentifier, offset: self.offset, limit: "")
//            }else{
////                self.loadCourses(with: "", userID: self.user_id as! String, limit: "10", offset: Int(self.offset), token: self.accessToken as! String)
//                self.getAllCourses(searchItem: "", categoryIds: "", identifier: self.listIdentifier, offset: "", limit: "")
//            }
        }
    }
    

}
