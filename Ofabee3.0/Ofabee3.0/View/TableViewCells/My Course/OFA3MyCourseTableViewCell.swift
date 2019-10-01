//
//  OFA3MyCourseTableViewCell.swift
//  Ofabee3.0
//
//  Created by Enfin on 04/09/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit
import SSProgressBar
import SDWebImage

class OFA3MyCourseTableViewCell: UITableViewCell {

    
    @IBOutlet weak var viewMyCourseInner: UIView!
    @IBOutlet weak var imageViewMyCourse: UIImageView!
    @IBOutlet weak var labelMyCourseTitle: UILabel!
    @IBOutlet weak var progressBarMyCourse: SSProgressBar!
    @IBOutlet weak var labelPercentageCompleted: UILabel!
    
    @IBOutlet weak var buttonPlayButton: UIButton!
    @IBOutlet weak var buttonStartOrResume: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customizeCellWithDetails(imageURL:String,courseTitle:String,coursePercentage:String,courseStatus:String,statusColor:UIColor){
        self.viewMyCourseInner.layer.cornerRadius = 4.0
        self.imageViewMyCourse.layer.cornerRadius = 4.0
        self.buttonPlayButton.layer.cornerRadius = 4.0
        self.viewMyCourseInner.dropShadow()
        self.progressBarMyCourse.progress = Int(coursePercentage)!
        self.progressBarMyCourse.withProgressGradientBackground(from: OFAUtils.getColorFromHexString(barTintColor), to: OFAUtils.getColorFromHexString(barTintColor), direction: .leftToRight)
        self.progressBarMyCourse.backgroundColor = OFAUtils.getColorFromHexString(sectionBackgroundColor)
        self.progressBarMyCourse.cornerRadius = 3.5
        
        self.imageViewMyCourse.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "EmptyCoursePlaceHolder"), options: .refreshCached, context: nil)
//        self.labelMyCourseTitle.font = UIFont(name: "Open Sans Regular", size: 12.0)
        if UIScreen.main.bounds.height <= 735{
            self.labelMyCourseTitle.font = UIFont(name: "OpenSans-Regular", size: 13.0)
        }else{
            self.labelMyCourseTitle.font = UIFont(name: "OpenSans-Regular", size: 17.0)
        }
        self.labelMyCourseTitle.text = courseTitle
        self.labelPercentageCompleted.text = coursePercentage + "%"
        self.buttonStartOrResume.setTitle(courseStatus, for: .normal)
        self.buttonStartOrResume.setTitleColor(statusColor, for: .normal)
    }

}
