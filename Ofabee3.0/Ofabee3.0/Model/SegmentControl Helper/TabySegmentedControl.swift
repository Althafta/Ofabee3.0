//
//  TabySegmentedControl.swift
//  UISegmentedControlAsTabbarDemo
//
//  Created by Ahmed Abdurrahman on 9/16/15.
//  Copyright © 2015 A. Abdurrahman. All rights reserved.
//

import UIKit

class TabySegmentedControl: UISegmentedControl {
    
//    func drawRect(){
//        super.drawRect()
//        initUI()
//    }
    
    func initUI(){
        setupBackground()
        setupFonts()
    }
    
    func setupBackground(){
        let backgroundImage = UIImage(named: "segmented_unselected_bg")?.withRenderingMode(.alwaysTemplate)
        let dividerImage = UIImage(named: "segmented_separator_bg")?.withRenderingMode(.alwaysTemplate)
        let backgroundImageSelected = UIImage(named: "segmented_selected_bg")?.withRenderingMode(.alwaysTemplate)
        self.tintColor = OFAUtils.getColorFromHexString(ofabeeGreenColorCode)
        self.backgroundColor = UIColor.white//OFAUtils.getColorFromHexString(barTintColor)
        
        self.setBackgroundImage(backgroundImage, for: UIControl.State(), barMetrics: .default)
        self.setBackgroundImage(backgroundImageSelected, for: .highlighted, barMetrics: .default)
        self.setBackgroundImage(backgroundImageSelected, for: .selected, barMetrics: .default)
        
        self.setDividerImage(dividerImage, forLeftSegmentState: UIControl.State(), rightSegmentState: .selected, barMetrics: .default)
        self.setDividerImage(dividerImage, forLeftSegmentState: .selected, rightSegmentState: UIControl.State(), barMetrics: .default)
        self.setDividerImage(dividerImage, forLeftSegmentState: UIControl.State(), rightSegmentState: UIControl.State(), barMetrics: .default)
    }
    
    func setupFonts(){
        let font = UIFont(name: "Avenir-Medium", size: 14.0)
        
        let normalTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: font
        ]
        
        let titleTextAttributes = [//UIColor(red: 95.0, green: 184.0, blue: 80.0, alpha: 1.0)
            NSAttributedString.Key.foregroundColor: OFAUtils.getColorFromHexString(ofabeeGreenColorCode),
            NSAttributedString.Key.font: font
        ]
        
        self.setTitleTextAttributes(normalTextAttributes as [NSAttributedString.Key : Any], for: .normal)
        self.setTitleTextAttributes(normalTextAttributes as [NSAttributedString.Key : Any], for: .highlighted)
        self.setTitleTextAttributes(titleTextAttributes as [NSAttributedString.Key : Any], for: .selected)
    }
    
}
