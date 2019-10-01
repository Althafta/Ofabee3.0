//
//  AppDelegate.swift
//  Ofabee3.0
//
//  Created by Enfin on 03/07/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.getCurrentCountryCode()
        let userId = UserDefaults.standard.value(forKey: USER_ID) as? String
        let userStatus = UserDefaults.standard.bool(forKey: isLOGGED_USER)
        if userId != nil && userStatus == true{
            self.autoLogin(userId: userId!)
        }
        return true
    }
    
    func getCurrentCountryCode(){
        Alamofire.request(userBaseURL+"current_location", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: [:]).responseJSON { (responseJSON) in
            if let dicResult = responseJSON.result.value as? NSDictionary{
                if let dicResponseMetaData = dicResult["metadata"] as? NSDictionary{
//                    print(dicResponseHeader)
                    if "\(dicResponseMetaData["status_code"]!)" != "200"{
                        OFAUtils.showToastWithTitle("\(dicResponseMetaData["message"]!)")
                        return
                    }
                }
                if let dicResponseData = dicResult["data"] as? NSDictionary{
                    UserDefaults.standard.set("\(dicResponseData["location_name"]!)", forKey: Country_Code)
                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "CountryFetchedNotification"), object: nil)
                }
            }else{
                UserDefaults.standard.set("IN", forKey: Country_Code)
                print("Country fetch failed")
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "CountryFetchedNotification"), object: nil)
            }
        }
    }
    
    func autoLogin(userId:String){
        let coreDataManager = OFA3CoreDataManager()
        let arrayUsers = coreDataManager.getAllUsersFromCoreData()
        let arrayFiltered = arrayUsers.filtered(using: NSPredicate(format: "user_id==%@", userId))
        if arrayFiltered.count > 0{
            let user = arrayFiltered.last as! User
            let dicData = NSDictionary(objects: [user.user_name!,user.user_email!,user.user_phone!,user.user_imageURL!,user.user_about!,user.user_id!,user.user_phone_verified!,user.user_email_verified!,user.user_category_id!], forKeys: ["us_name" as NSCopying,"us_email" as NSCopying,"us_phone" as NSCopying,"us_image" as NSCopying,"us_about" as NSCopying,"user_id" as NSCopying,"us_phone_verfified" as NSCopying,"us_email_verified" as NSCopying,"us_category_id" as NSCopying])
            OFA3SingletonUser.ofabeeUser.updateUserDetailsFromCoreData(dicData: dicData)
            self.initializeHomePage()
        }else{
            self.initializeLoginPage()
        }
    }

    func logout(){
        
        let coreDataManager = OFA3CoreDataManager()
        coreDataManager.deleteAnUser(with: UserDefaults.standard.value(forKey: USER_ID) as! String)
        
        UserDefaults.standard.removeObject(forKey: USER_ID)
        UserDefaults.standard.removeObject(forKey: isLOGGED_USER)
        UserDefaults.standard.removeObject(forKey: USER_ID)
        self.initializeLoginPage()
        
        self.signOutAPICall() //API call for signout
    }
    
    func initializeHomePage(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let homePageNavigation = storyBoard.instantiateViewController(withIdentifier: "TabBarNVC") as! OFA3HomeNavigationViewController
        self.window?.rootViewController = homePageNavigation
        self.window?.makeKeyAndVisible()
    }
    
    func initializeLoginPage(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginPageNavigation = storyBoard.instantiateViewController(withIdentifier: "LoginNVC")
        self.window?.rootViewController = loginPageNavigation
        self.window?.makeKeyAndVisible()
    }
    
    func signOutAPICall(){
        let dicHeader = NSDictionary(objects: ["Bearer \(UserDefaults.standard.value(forKey: ACCESS_TOKEN) as! String)"], forKeys: ["Authorization" as NSCopying])
        OFAUtils.showLoadingViewWithTitle(nil)
        Alamofire.request(userBaseURL+"signout", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: dicHeader as? HTTPHeaders).responseJSON { (responseJSON) in
            if let dicResponse = responseJSON.result.value as? NSDictionary{
                OFAUtils.removeLoadingView(nil)
                if let dicResponseMetaData = dicResponse["metadata"] as? NSDictionary{
                    if "\(dicResponseMetaData["status_code"]!)" != "200"{
                        OFAUtils.showToastWithTitle("\(dicResponseMetaData["message"]!)")
                        return
                    }
                }
                if let dicResponseData = dicResponse["data"] as? NSDictionary{
                    print(dicResponseData)
//                    let coreDataManager = OFA3CoreDataManager()
//                    coreDataManager.deleteAnUser(with: UserDefaults.standard.value(forKey: USER_ID) as! String)
//                    UserDefaults.standard.removeObject(forKey: USER_ID)
                    UserDefaults.standard.removeObject(forKey: ACCESS_TOKEN)
//                    UserDefaults.standard.removeObject(forKey: isLOGGED_USER)
//                    self.initializeLoginPage()
                }
            }else{
                OFAUtils.removeLoadingView(nil)
                OFAUtils.showAlertViewControllerWithTitle(nil, message: responseJSON.error?.localizedDescription, cancelButtonTitle: "OK")
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Ofabee3_0")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

