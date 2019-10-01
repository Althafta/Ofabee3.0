//
//  OFA3LeftSideBubbleTableViewController.swift
//  TestApp
//
//  Created by Enfin on 26/06/19.
//  Copyright © 2019 Administrator. All rights reserved.
//

import UIKit
import BubbleTransition
import SDWebImage

class OFA3LeftSideBubbleTableViewController: UITableViewController {

    @IBOutlet var viewBackground: UIView!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var imageViewProfileImage: UIImageView!
    
    weak var interactiveTransition = BubbleInteractiveTransition()
    
//    var arrayTitle = ["Home","Notifications","Messages","Support Chat","Bookmarks","Wishlist","F A Q","Share Ofabee"]
    var arrayTitle = ["Home","F A Q","Share Ofabee"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor.clear
        let imageView = UIImageView(image: UIImage(named: "MenuBG"))
        imageView.contentMode = .scaleAspectFill
        self.tableView.backgroundView = viewBackground
        self.tableView.separatorStyle = .none
        
        self.buttonClose.layer.cornerRadius = self.buttonClose.frame.height/2
        self.imageViewProfileImage.layer.cornerRadius = self.imageViewProfileImage.frame.height/2
        
        if OFA3SingletonUser.ofabeeUser.user_imageURL != nil{
            self.imageViewProfileImage.sd_setImage(with: URL(string: OFA3SingletonUser.ofabeeUser.user_imageURL!), placeholderImage: UIImage(named: "EmptyProfilePlaceHolder"), options: .progressiveLoad, context: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.profileEditNotification), name: NSNotification.Name.init(rawValue: "EditProfileImageNotification"), object: nil)
    }
    
    @objc func profileEditNotification(){
        if OFA3SingletonUser.ofabeeUser.user_imageURL != nil{
                   self.imageViewProfileImage.sd_setImage(with: URL(string: OFA3SingletonUser.ofabeeUser.user_imageURL!), placeholderImage: UIImage(named: "EmptyProfilePlaceHolder"), options: .progressiveLoad, context: nil)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTitle.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)

        cell.textLabel?.font = UIFont(name: "OpenSans-Regular", size: 17.0)
        cell.textLabel?.text = self.arrayTitle[indexPath.row]
        cell.textLabel?.textColor = .white

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        interactiveTransition?.finish()
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: SideMenuNotification), object: nil)
        if indexPath.row == 0{
            (UIApplication.shared.delegate as! AppDelegate).initializeHomePage()
        }else if indexPath.row == 2{
            let shareText = "Hi Ofabee 3.0 "
            let shareOfabeeActivityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
            shareOfabeeActivityVC.popoverPresentationController?.sourceView = self.view
            UIApplication.shared.keyWindow?.rootViewController?.present(shareOfabeeActivityVC, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @IBAction func closeMenuPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        interactiveTransition?.finish()
    }
    
    func logout(){
        (UIApplication.shared.delegate as! AppDelegate).logout()
    }
}
