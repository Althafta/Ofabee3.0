//
//  OFA3CategorySelectionListTableViewCell.swift
//  Ofabee3.0
//
//  Created by Enfin on 08/08/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit

class OFA3CategorySelectionListTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewCategoryIcon: UIImageView!
    @IBOutlet weak var labelCategoryName: UILabel!
    @IBOutlet weak var buttonCategorySelection: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
