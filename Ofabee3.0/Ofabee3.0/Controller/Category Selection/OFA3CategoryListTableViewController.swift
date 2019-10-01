//
//  OFA3CategoryListTableViewController.swift
//  Ofabee3.0
//
//  Created by Enfin on 08/08/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit
import Alamofire

protocol categorySelectionDelegate {
    func didSelectCategories(arraySelectedCategories:[String])
}

class OFA3CategoryListTableViewController: UITableViewController {
    
    var arrayCategoryList = NSMutableArray()
    var delegate:categorySelectionDelegate!
    var arraySelectedCategory = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.white//.withAlphaComponent(0.3)
        self.getCategories()
    }

    //MARK:- Get Categories - API
    
    func getCategories(){
        var dicHeader = NSDictionary()
        if let accesToken = UserDefaults.standard.value(forKey: ACCESS_TOKEN) as? String{
            dicHeader = NSDictionary(objects: ["Bearer \(accesToken)"], forKeys: ["Authorization" as NSCopying])
        }else{
            dicHeader = NSDictionary()
        }
        OFAUtils.showLoadingViewWithTitle("Loading")
        Alamofire.request(userBaseURL+"categories", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: dicHeader as? HTTPHeaders).responseJSON { (responseJSON) in
            if let dicResult = responseJSON.result.value as? NSDictionary{
                OFAUtils.removeLoadingView(nil)
                if let arrayCategoryList = dicResult["data"] as? NSArray{
                    for item in arrayCategoryList{
                        let dicCategory = item as! NSDictionary
                        if let categorySelected = dicCategory["selected"] as? Bool{
                            if categorySelected == true{
                                if !self.arraySelectedCategory.contains("\(dicCategory["id"]!)"){
                                    self.arraySelectedCategory.append("\(dicCategory["id"]!)")
                                }else{
                                    self.arraySelectedCategory.remove(at: self.arraySelectedCategory.firstIndex(of: "\(dicCategory["id"]!)")!)
                                }
                            }
                        }else{
//                            cell.buttonCategorySelection.isSelected = false
                        }
                        if !self.arrayCategoryList.contains(dicCategory){
                            self.arrayCategoryList.add(dicCategory)
                        }
                        self.tableView.reloadData()
                    }
                }else{
                    let dicResponseMetaData = dicResult["metadata"] as! NSDictionary
                    OFAUtils.showAlertViewControllerWithTitle("Warning", message: "\(dicResponseMetaData["message"]!)", cancelButtonTitle: "OK")
                }
                
            }else{
                OFAUtils.removeLoadingView(nil)
                OFAUtils.showAlertViewControllerWithTitle(nil, message: responseJSON.error?.localizedDescription, cancelButtonTitle: "OK")
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayCategoryList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categorySelectionCell", for: indexPath) as! OFA3CategorySelectionListTableViewCell
        
        let dicCategory = self.arrayCategoryList[indexPath.row] as! NSDictionary
//        print(dicCategory)
        cell.labelCategoryName.text = "\(dicCategory["ct_name"]!)"
        if let categorySelected = dicCategory["selected"] as? Bool{
            cell.buttonCategorySelection.isSelected = categorySelected
        }else{
            cell.buttonCategorySelection.isSelected = false
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! OFA3CategorySelectionListTableViewCell
        var dicCategory = self.arrayCategoryList[indexPath.row] as! Dictionary<String,Any>
        cell.buttonCategorySelection.isSelected = !cell.buttonCategorySelection.isSelected
        if !self.arraySelectedCategory.contains("\(dicCategory["id"]!)"){
            dicCategory["selected"] = true
            self.arraySelectedCategory.append("\(dicCategory["id"]!)")
        }else{
            dicCategory["selected"] = false
            self.arraySelectedCategory.remove(at: self.arraySelectedCategory.firstIndex(of: "\(dicCategory["id"]!)")!)
        }
        self.arrayCategoryList.replaceObject(at: indexPath.row, with: dicCategory)
        self.delegate.didSelectCategories(arraySelectedCategories: self.arraySelectedCategory)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    //MARK:- Button Actions
    
    @IBAction func categorySelectionPressed(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
        
    }
}
