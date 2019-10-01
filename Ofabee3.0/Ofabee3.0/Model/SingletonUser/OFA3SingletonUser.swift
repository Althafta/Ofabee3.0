//
//  OFA3SingletonUser.swift
//  Ofabee3.0
//
//  Created by Enfin on 27/08/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit

class OFA3SingletonUser: NSObject {
    class var ofabeeUser : OFA3SingletonUser {
        struct user {
            static var instance = OFA3SingletonUser()
        }
        return user.instance
    }
    
    var user_name : String?
    var user_email : String?
    var user_imageURL : String?
    var user_phone : String?
    var user_about : String?
    var user_id : String?
    
    var user_email_verified : String?
    var user_phone_verified : String?
    var user_category_id : String?
    
    func initWithDictionary(dicData:NSDictionary){
        self.user_name = HandleNullValues.string(toCheckNull: dicData["us_name"] as? String)
        self.user_email = HandleNullValues.string(toCheckNull: dicData["us_email"] as? String)
        self.user_imageURL = HandleNullValues.string(toCheckNull: dicData["us_image"] as? String)
        self.user_phone = HandleNullValues.string(toCheckNull: dicData["us_phone"] as? String)
        self.user_about = HandleNullValues.string(toCheckNull: dicData["us_about"] as? String)
        self.user_id = "\(dicData["id"]!)"
        
        self.user_email_verified = "\(dicData["us_email_verified"]!)"
        self.user_phone_verified = "\(dicData["us_phone_verfified"]!)"
        self.user_category_id = HandleNullValues.string(toCheckNull: dicData["us_category_id"] as? String)
    }
    
    func updateUserDetailsFromCoreData(dicData:NSDictionary){
        self.user_name = HandleNullValues.string(toCheckNull: dicData["us_name"] as? String)
        self.user_email = HandleNullValues.string(toCheckNull: dicData["us_email"] as? String)
        self.user_imageURL = "\(dicData["us_image"]!)"
        self.user_phone = HandleNullValues.string(toCheckNull: dicData["us_phone"] as? String)
        self.user_about = HandleNullValues.string(toCheckNull: dicData["us_about"] as? String)
        self.user_id = "\(dicData["user_id"]!)"
        
        self.user_email_verified = "\(dicData["us_email_verified"]!)"
        self.user_phone_verified = "\(dicData["us_phone_verfified"]!)"
        self.user_category_id = HandleNullValues.string(toCheckNull: dicData["us_category_id"] as? String)
        
//        .user_name = HandleNullValues.string(toCheckNull: dicUser["us_name"] as? String)//
//        .user_email = HandleNullValues.string(toCheckNull: dicUser["us_email"] as? String)//
//        .user_imageURL = HandleNullValues.string(toCheckNull: dicUser["us_image"] as? String)//
//        .user_phone = HandleNullValues.string(toCheckNull: dicUser["us_phone"] as? String)//
//        .user_about = HandleNullValues.string(toCheckNull: dicUser["us_about"] as? String)//
//        .user_id = "\(dicUser["id"]!)"//
//        .user_category_id = HandleNullValues.string(toCheckNull: dicUser["us_category_id"] as? String)//
//        .user_email_verified = "\(dicUser["us_email_verified"]!)"//
//        .user_phone_verified = "\(dicUser["us_phone_verfified"]!)"//
        
    }
    
    func updateProfileDetails(dicData:NSDictionary){
        self.user_name = HandleNullValues.string(toCheckNull: dicData["us_name"] as? String)
        self.user_phone = HandleNullValues.string(toCheckNull: dicData["us_phone"] as? String)
        self.user_imageURL = "\(dicData["us_image"]!)"
    }
}
