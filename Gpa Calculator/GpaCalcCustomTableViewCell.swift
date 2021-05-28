//
//  GpaCalcCustomTableViewCell.swift
//  Gpa Calculator
//
//  Created by Brian on 4/7/20.
//  Copyright © 2020 Brian. All rights reserved.
//

import UIKit

class GpaCalcCustomTableViewCell: UITableViewCell {
    @IBOutlet weak var classTitleLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
