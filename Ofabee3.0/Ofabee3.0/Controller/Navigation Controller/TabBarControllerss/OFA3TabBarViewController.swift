//
//  OFA3TabBarViewController.swift
//  Ofabee3.0
//
//  Created by Enfin on 22/08/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit

class OFA3TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setNavigationBarItem()
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveSideMenuNotification), name: NSNotification.Name.init(rawValue: SideMenuNotification), object: nil)
//        self.navigationItem.title = self.tabBar.selectedItem?.title == "Home" ? "Home" : ""
         self.navigationItem.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func receiveSideMenuNotification(){
//        let registerPage = self.storyboard?.instantiateViewController(withIdentifier: "RegisterTVC") as! OFA3RegisterTableViewController
//        self.navigationController?.pushViewController(registerPage, animated: false)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Home"{
            self.navigationItem.title = ""
        }else if item.title == "My Course"{
            self.navigationItem.title = "My Courses"
        }else if item.title == "Explore"{
            self.navigationItem.title = "Explore Courses"
        }else if item.title == "Profile"{
            self.navigationItem.title = "My Account"
        }
    }
}
