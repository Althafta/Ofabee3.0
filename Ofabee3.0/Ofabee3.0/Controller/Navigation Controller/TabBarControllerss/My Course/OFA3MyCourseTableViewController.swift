//
//  OFA3MyCourseTableViewController.swift
//  Ofabee3.0
//
//  Created by Enfin on 04/09/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit
import Alamofire

class OFA3MyCourseTableViewController: UITableViewController {

    var arrayMyCourses = NSMutableArray()
    let accessToken = UserDefaults.standard.value(forKey: ACCESS_TOKEN)
    var refreshController = UIRefreshControl()
    @IBOutlet var viewMessage: UIView!
//    @IBOutlet weak var viewStripTop: UIView!
    @IBOutlet weak var labelMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setNavigationBarItem()
        self.refreshController.tintColor = OFAUtils.getColorFromHexString(barTintColor)
        self.refreshController.addTarget(self, action: #selector(self.refreshInitiated), for: .valueChanged)
        self.tableView.addSubview(self.refreshController)
        
        self.labelMessage.text = "Loading..."
        self.tableView.backgroundView = self.viewMessage
//        self.viewStripTop.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "My Courses"
        self.tabBarController?.navigationItem.title = "My Courses"
        self.getMyCourses()
    }

    @objc func refreshInitiated(){
        self.getMyCourses()
    }
    
    func getMyCourses(){
        let dicHeader = NSDictionary(objects: ["Bearer \(self.accessToken as! String)"], forKeys: ["Authorization" as NSCopying])
//        OFAUtils.showLoadingViewWithTitle("Loading")
        Alamofire.request(userBaseURL+"my_courses", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: dicHeader as? HTTPHeaders).responseJSON { (responseJSON) in
            if let dicResponse = responseJSON.result.value as? NSDictionary{
//                OFAUtils.removeLoadingView(nil)
                if let dicResponseMetaData = dicResponse["metadata"] as? NSDictionary{
                    if "\(dicResponseMetaData["status_code"]!)" == "401"{
                        let sessionAlert = UIAlertController(title: "Session Expired", message: nil, preferredStyle: .alert)
                        sessionAlert.addAction(UIAlertAction(title: "Login Again", style: .default, handler: { (action) in
                            (UIApplication.shared.delegate as! AppDelegate).logout()
                        }))
                        
                        self.present(sessionAlert, animated: true, completion: nil)
                        return
                    }else if "\(dicResponseMetaData["status_code"]!)" != "200"{
                        self.labelMessage.text = "\(dicResponseMetaData["message"]!)"
                        self.tableView.backgroundView = self.viewMessage
//                        self.viewStripTop.isHidden = true
                        self.refreshController.endRefreshing()
                        return
                    }
                }
                if let arrayMyCourseList = dicResponse["data"] as? NSArray{
                    self.arrayMyCourses = arrayMyCourseList.mutableCopy() as! NSMutableArray
                    self.tableView.backgroundView = nil
//                    self.viewStripTop.isHidden = false
                }
                self.refreshController.endRefreshing()
                self.tableView.reloadData()
            }else{
//                OFAUtils.removeLoadingView(nil)
                OFAUtils.showAlertViewControllerWithTitle(nil, message: responseJSON.error?.localizedDescription, cancelButtonTitle: "OK")
            }

        }
    }
    
    func getExpiryDetails(numberOfDays:Int, percentageCompleted:String)->[String]{
        var courseStatus = ""
        var colorCode = ""
        if numberOfDays == 1{
            courseStatus = "Expires Today"
            colorCode = materialRedColor
        }else if numberOfDays == 2{
            courseStatus = "Expires Tomorrow"
            colorCode = "FFA500"
        }else if numberOfDays <= 5{
            courseStatus = "Expires in \(numberOfDays) days"
            colorCode = "FFA500"
        }else{
            if percentageCompleted != "0"{
                courseStatus = "Resume Course"
            }else{
                courseStatus = "Start Course"
            }
            if percentageCompleted == "100"{
                courseStatus = "Course Completed"
            }
            colorCode = "26ABC4"
        }
        return [courseStatus,colorCode]
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayMyCourses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCourseCell", for: indexPath) as! OFA3MyCourseTableViewCell

        let dicCourseDetails = self.arrayMyCourses[indexPath.row] as! NSDictionary
        
        var courseStatus = ""
        var colorCode = ""
        if "\(dicCourseDetails["expired"]!)" == "1"{
            courseStatus = "Course Expired"
            colorCode = materialRedColor
        }else{
            courseStatus = self.getExpiryDetails(numberOfDays: Int("\(dicCourseDetails["expire_in_days"]!)")!, percentageCompleted: "\(dicCourseDetails["course_completion"]!)")[0]
            colorCode = self.getExpiryDetails(numberOfDays: Int("\(dicCourseDetails["expire_in_days"]!)")!, percentageCompleted: "\(dicCourseDetails["course_completion"]!)")[1]
        }
        cell.customizeCellWithDetails(imageURL: "\(dicCourseDetails["cb_image"]!)", courseTitle: "\(dicCourseDetails["cb_title"]!)", coursePercentage: "\(dicCourseDetails["cs_percentage"]!)", courseStatus: courseStatus, statusColor: OFAUtils.getColorFromHexString(colorCode))
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webViewContentDelivery = self.storyboard?.instantiateViewController(withIdentifier: "WebViewMyCourseDetails") as! OFA3WebViewMyCourseViewController
        let dicCourseDetails = self.arrayMyCourses[indexPath.row] as! NSDictionary
        
        
        if "\(dicCourseDetails["expired"]!)" == "1"{
//            let sessionAlert = UIAlertController(title: "Course Expired", message: nil, preferredStyle: .alert)
//            sessionAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
////                (UIApplication.shared.delegate as! AppDelegate).logout()
//            }))
//
//            self.present(sessionAlert, animated: true, completion: nil)
            OFAUtils.showAlertViewControllerWithinViewControllerWithTitle(viewController: self, alertTitle: nil, message: "Course Expired", cancelButtonTitle: "OK")
        }else{
            //        print(dicCourseDetails)
            //        let url = Bundle.main.url(forResource: "build/index", withExtension: "html")!
            
            webViewContentDelivery.contentDeliveryAppendURL = "?host=testing-neyyar.enfinlabs.com&token=\(self.accessToken as! String)#/\(dicCourseDetails["course_id"]!)"
            //        webViewContentDelivery.courseContentURL = url.absoluteString + "?token=\(self.accessToken as! String)#/\(dicCourseDetails["course_id"]!)"
            //        webViewContentDelivery.courseContentURL = "https://testing-neyyar.enfinlabs.com/materials/course/\(dicCourseDetails["course_id"]!)?token=\(self.accessToken as! String)"
            self.tabBarController?.navigationItem.title = ""
            self.navigationController?.pushViewController(webViewContentDelivery, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        print(UIScreen.main.bounds.height)
        if UIScreen.main.bounds.height <= 735{
            return 95
        }else{
            return 120
        }
    }
}
