//
//  OFA3HomeFeaturedCoursesTableViewCell.swift
//  Ofabee3.0
//
//  Created by Enfin on 17/09/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit

protocol HomeFeaturedCourseDelegate {
    func getArrayFeatureCourseDetails(array:NSArray)
    func pushToNextPageFromFeatureCourse(childVewController:UIViewController)
}

class OFA3HomeFeaturedCoursesTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,featureCourseCellDelegate {

    @IBOutlet weak var collectionViewFeaturedCourses: UICollectionView!
    var arrayFeaturedCourses = NSMutableArray()
    var delegate:HomeFeaturedCourseDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayFeaturedCourses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionViewFeaturedCourses.dequeueReusableCell(withReuseIdentifier: "FeaturedCoursesCell", for: indexPath) as! OFA3FeaturedCoursesCollectionViewCell
        
        let dicFeaturedCourse = self.arrayFeaturedCourses[indexPath.row] as! NSDictionary
        var rating = ""
        if "\(dicFeaturedCourse["item_rating"]!)" == ""{
            rating = "0"
        }else{
            rating = "\(dicFeaturedCourse["item_rating"]!)"
        }
        cell.delegate = self
        cell.row = indexPath.row
        var boolGradient = false
        if let isGradApplied = dicFeaturedCourse["is_grad_applied"] as? Bool{
            if !isGradApplied{
//                cell.addGradientToView(view: cell.viewImageOverlay)
                boolGradient = false
            }else{
                boolGradient = true
            }
        }else{
            boolGradient = false
        }
        cell.customizeItemWithDetails(imageURL: "\(dicFeaturedCourse["item_image"]!)", courseTitle: "\(dicFeaturedCourse["item_name"]!)", ratingCount: "\(dicFeaturedCourse["item_id"]!)", coursePrice: "\(dicFeaturedCourse["item_discount"]!)", ratingValue: rating, gradientApplied: boolGradient)
       
//        cell.addGradientToView(view: cell.viewImageOverlay)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard()
//        let vc = storyboard.instantiateViewController(withIdentifier: "sample")
        let alertController = UIAlertController(title: "Warning", message: "Please contact Administrator to activate the course", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            
        }))
        self.delegate.pushToNextPageFromFeatureCourse(childVewController: alertController)
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 280, height: 172)
//    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.backgroundColor = OFAUtils.getColorFromHexString(sectionBackgroundColor)
    }
    
    func updateCellDetails(isGradientApplied: Bool, for cell: Int) {
        var dicFeaturedCourse = self.arrayFeaturedCourses[cell] as! Dictionary<String,Any>
        dicFeaturedCourse["is_grad_applied"] = isGradientApplied
//        print(dicFeaturedCourse)
        self.arrayFeaturedCourses.replaceObject(at: cell, with: dicFeaturedCourse)
        self.collectionViewFeaturedCourses.reloadData()
    }
}
