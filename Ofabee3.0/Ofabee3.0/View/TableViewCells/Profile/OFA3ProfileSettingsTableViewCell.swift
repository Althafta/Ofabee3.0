//
//  OFA3ProfileSettingsTableViewCell.swift
//  Ofabee3.0
//
//  Created by Enfin on 05/09/19.
//  Copyright © 2019 Enfin. All rights reserved.
//

import UIKit

class OFA3ProfileSettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var labelSettingsMenu: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
