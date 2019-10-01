//
//  OFA3ExploreCoursesTableViewController.swift
//  Ofabee3.0
//
//  Created by Enfin on 01/10/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit

class OFA3ExploreCoursesTableViewController: UITableViewController {
    
    var arrayExploreCourses = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExplorelCoursesListCell", for: indexPath) as! OFA3ExploreCourseListTableViewCell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIScreen.main.bounds.height <= 735{
            return 100
        }else{
            return 125
        }
    }
}
