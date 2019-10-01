//
//  OFA3FeaturedCoursesCollectionViewCell.swift
//  Ofabee3.0
//
//  Created by Enfin on 17/09/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit
import SDWebImage
import FloatRatingView

protocol featureCourseCellDelegate {
    func updateCellDetails(isGradientApplied:Bool,for cell:Int)
}

class OFA3FeaturedCoursesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewFeaturedCourse: UIImageView!
    @IBOutlet weak var labelCourseTitle: UILabel!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var labelRatingCount: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    @IBOutlet weak var viewImageOverlay: UIView!
    
    var delegate:featureCourseCellDelegate!
    var row = Int()
    
    func customizeItemWithDetails(imageURL:String,courseTitle:String,ratingCount:String,coursePrice:String,ratingValue:String,gradientApplied:Bool){
        self.imageViewFeaturedCourse.sd_setImage(with: URL(string: imageURL)!, placeholderImage: UIImage(named: "EmptyCoursePlaceHolder"), options: .progressiveLoad, context: nil)
        self.imageViewFeaturedCourse.layer.cornerRadius = 2.0
        self.viewImageOverlay.layer.cornerRadius = 2.0
        
//        let intrinsicSize
//        self.labelCourseTitle.intrinsicContentSize = CGSize()
        
        self.labelCourseTitle.text = courseTitle
        self.labelRatingCount.text = "(\(ratingCount))"
        if coursePrice == "0"{
            self.labelPrice.text = "Free"
        }else{
            self.labelPrice.text = "\(ruppeeSymbol) " + coursePrice
        }
        self.starRatingView.rating = (ratingValue as NSString).floatValue
        
//        self.viewImageOverlay.removeFromSuperview()
//        self.addGradientToView(view: self.viewImageOverlay)
//        self.addSubview(self.viewImageOverlay)
//        if !gradientApplied{
//            self.addGradientToView(view: self.viewImageOverlay)
//        }
//        self.delegate.updateCellDetails(isGradientApplied: gradientApplied, for: self.row)
    }
    
    func addGradientToView(view: UIView){
        //gradient layer
        let gradientLayer = CAGradientLayer()
        //define colors
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0.2).cgColor,UIColor.white.withAlphaComponent(0.4).cgColor, UIColor.black.withAlphaComponent(0.6).cgColor]
        //define locations of colors as NSNumbers in range from 0.0 to 1.0
        //if locations not provided the colors will spread evenly
        gradientLayer.locations = [0.0, 0.5, 0.8]
        //define frame
        gradientLayer.frame = view.bounds
        //insert the gradient layer to the view layer
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
       super.layoutSubviews()
       if !(self.layer.sublayers?.first is CAGradientLayer) {
           CATransaction.begin()
           CATransaction.setDisableActions(true)
//           UIUtils.setGradientWhite(uiView: self)
        self.addGradientToView(view: self.viewImageOverlay)
           CATransaction.commit()
       }
    }
}
