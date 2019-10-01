//
//  OFA3HomePopularCoursesTableViewCell.swift
//  Ofabee3.0
//
//  Created by Enfin on 17/09/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit

protocol HomePopularCourseDelegate {
    func getArrayPopularCourseDetails(array:NSArray)
    func pushToNextPageFromPopularCourse(childVewController:UIViewController)
}

class OFA3HomePopularCoursesTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableViewPopularCourses: UITableView!
    var arrayPopularCourses = NSMutableArray()
    var delegate : HomePopularCourseDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayPopularCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewPopularCourses.dequeueReusableCell(withIdentifier: "PopularCourseCell", for: indexPath) as! OFA3PopularCoursesTableViewCell
        let dicPopularCourse = self.arrayPopularCourses[indexPath.row] as! NSDictionary
        var isBundle = false
        if "\(dicPopularCourse["item_type"]!)" == "bundle"{
            isBundle = true
        }else{
            isBundle = false
        }
        
        cell.customizeCellWithDetails(imageURL: "\(dicPopularCourse["item_image"]!)", courseTitle: "\(dicPopularCourse["item_name"]!)", categories: dicPopularCourse["item_category"] as! NSArray, ratingValue: "\(dicPopularCourse["item_rating"]!)", ratingCount: "\(dicPopularCourse["item_id"]!)", isBundle: isBundle, courseOriginalPrice: "\(dicPopularCourse["item_price"]!)", courseDiscountPrice: "\(dicPopularCourse["item_discount"]!)", freeStatus: "\(dicPopularCourse["item_is_free"]!)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //        let storyboard = UIStoryboard()
        //        let vc = storyboard.instantiateViewController(withIdentifier: "sample")
        //        self.delegate.pushToNextPageFromPopularCourse(childVewController: vc)
        let storyboard = UIStoryboard()
        //        let vc = storyboard.instantiateViewController(withIdentifier: "sample")
        let alertController = UIAlertController(title: "Warning", message: "Please contact Administrator to activate the course", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            
        }))
        self.delegate.pushToNextPageFromPopularCourse(childVewController: alertController)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIScreen.main.bounds.height <= 735{
            return 100
        }else{
            return 125
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = OFAUtils.getColorFromHexString(sectionBackgroundColor)
//        if self.arrayPopularCourses.count == indexPath.row + 1{
//            self.delegate.getArrayPopularCourseDetails(array: self.arrayPopularCourses.mutableCopy() as! NSArray)
//        }
    }

}
