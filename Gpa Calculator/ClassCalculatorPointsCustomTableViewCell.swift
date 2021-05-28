//
//  ClassCalculatorPointsCustomTableViewCell.swift
//  Gpa Calculator
//
//  Created by Brian on 4/26/20.
//  Copyright © 2020 Brian. All rights reserved.
//

import UIKit

class ClassCalculatorPointsCustomTableViewCell: UITableViewCell {
    @IBOutlet weak var pointsRecievedTextField: UITextField!
    @IBOutlet weak var pointsPossibleTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
