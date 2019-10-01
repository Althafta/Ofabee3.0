//
//  OFA3ExploreCourseListTableViewCell.swift
//  Ofabee3.0
//
//  Created by Enfin on 01/10/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit
import SDWebImage
import FloatRatingView

class OFA3ExploreCourseListTableViewCell: UITableViewCell {

    @IBOutlet weak var labelCourseTitle: UILabel!
    @IBOutlet weak var imageViewCourse: UIImageView!
    @IBOutlet weak var viewInnerExploreCourse: UIView!
    @IBOutlet weak var viewImageOverlay: UIView!
    
    @IBOutlet weak var labelCategories: UILabel!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var labelRatingCount: UILabel!
    @IBOutlet weak var buttonCombo: UIButton!
    @IBOutlet weak var labelCourseDiscountPrice: UILabel!
    @IBOutlet weak var labelCourseOriginalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customizeCellWithDetails(imageURL:String,courseTitle:String,categories:NSArray,ratingValue:String,ratingCount:String,isBundle:Bool,courseOriginalPrice:String,courseDiscountPrice:String,freeStatus:String){
        self.imageViewCourse.sd_setImage(with: URL(string: imageURL)!, placeholderImage: UIImage(named: ""), options: .refreshCached, context: nil)
        self.labelCourseTitle.text = courseTitle
        
        self.viewInnerExploreCourse.layer.cornerRadius = 4.0
        self.viewImageOverlay.layer.cornerRadius = 4.0
        self.imageViewCourse.layer.cornerRadius = 4.0
        
        self.buttonCombo.layer.cornerRadius = self.buttonCombo.frame.height/2
        
        self.buttonCombo.isHidden = !isBundle
        
        self.labelRatingCount.text = "(\(ratingCount))"
        var arrayNames = [String]()
        for item in categories{
            arrayNames.append("\((item as! NSDictionary)["ct_name"]!)")
        }
        self.labelCategories.text = arrayNames.joined(separator: ",")
        //"\u{24}"
        self.labelCourseDiscountPrice.text = "\(ruppeeSymbol) "+courseDiscountPrice//U+20B9
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(ruppeeSymbol) \(courseOriginalPrice)")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.red, range: NSMakeRange(0, attributeString.length))
        self.labelCourseOriginalPrice.attributedText = attributeString
        let ratingVal = ratingValue != "" ? ratingValue : "0"
        starRatingView.rating = (ratingVal as NSString).floatValue
        
        if courseDiscountPrice == "0" && courseOriginalPrice != "0"{
            self.labelCourseDiscountPrice.text = "\(ruppeeSymbol)  \(courseOriginalPrice)"
            self.labelCourseOriginalPrice.isHidden = true
        }else{
            self.labelCourseOriginalPrice.isHidden = false
        }
        
        if freeStatus == "1"{
            self.labelCourseOriginalPrice.isHidden = true
            self.labelCourseDiscountPrice.text = "Free"
        }else{
            self.labelCourseOriginalPrice.isHidden = false
        }
        if arraySmallDevices.contains(UIDevice.modelName){
            self.starRatingView.isHidden = true
            self.labelRatingCount.isHidden = true
        }else{
            self.starRatingView.isHidden = false
            self.labelRatingCount.isHidden = false
        }
    }

}
