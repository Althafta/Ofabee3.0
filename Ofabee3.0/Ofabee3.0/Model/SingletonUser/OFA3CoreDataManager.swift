//
//  OFA3CoreDataManager.swift
//  Ofabee3.0
//
//  Created by Enfin on 28/08/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit

class OFA3CoreDataManager: NSObject {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let coreDataUser = User(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveUserDetails(toCoreDataWith dicUser : NSDictionary){
        coreDataUser.user_name = HandleNullValues.string(toCheckNull: dicUser["us_name"] as? String)
        coreDataUser.user_email = HandleNullValues.string(toCheckNull: dicUser["us_email"] as? String)
        coreDataUser.user_imageURL = HandleNullValues.string(toCheckNull: dicUser["us_image"] as? String)
        coreDataUser.user_phone = HandleNullValues.string(toCheckNull: dicUser["us_phone"] as? String)
        coreDataUser.user_about = HandleNullValues.string(toCheckNull: dicUser["us_about"] as? String)
        coreDataUser.user_id = "\(dicUser["id"]!)"
        coreDataUser.user_category_id = HandleNullValues.string(toCheckNull: dicUser["us_category_id"] as? String)
        coreDataUser.user_email_verified = "\(dicUser["us_email_verified"]!)"
        coreDataUser.user_phone_verified = "\(dicUser["us_phone_verfified"]!)"
        
        delegate.saveContext()
        UserDefaults.standard.set(true, forKey: isLOGGED_USER)
    }
    
    func saveUserData(key:String,value:String){
         let userId = UserDefaults.standard.value(forKey: USER_ID) as! String
        let filteredUser = self.getAllUsersFromCoreData().filtered(using: NSPredicate(format: "user_id==%@", userId)) as NSArray
        if filteredUser.count > 0{
            let user = filteredUser.lastObject as! User
            user.user_name = value
        }
        delegate.saveContext()
    }
    
    func saveUserImage(key:String,value:String){
        let userId = UserDefaults.standard.value(forKey: USER_ID) as! String
        let filteredUser = self.getAllUsersFromCoreData().filtered(using: NSPredicate(format: "user_id==%@", userId)) as NSArray
        if filteredUser.count > 0{
            let user = filteredUser.lastObject as! User
            user.user_imageURL = value
        }
        delegate.saveContext()
    }
    
    func deleteAnUser(with user_id:String){
        let arrayAllUsers = self.getAllUsersFromCoreData()
        for anUser in arrayAllUsers{
            self.context.delete(anUser as! User)
        }
        do {
            try context.save() // <- remember to put this :)
        } catch {
            print(("Coredata User not deleted"))
        }
    }

    func getAllUsersFromCoreData()->NSArray{
        var arrayResult = NSArray()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            arrayResult = try context.fetch(User.fetchRequest()) as NSArray
        }catch{
            print("Error while fetching CoreData")
        }
        return arrayResult
    }
}
