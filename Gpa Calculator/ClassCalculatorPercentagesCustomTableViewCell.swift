//
//  ClassCalculatorPercentagesCustomTableViewCell.swift
//  Gpa Calculator
//
//  Created by Brian on 5/15/20.
//  Copyright © 2020 Brian. All rights reserved.
//

import UIKit

class ClassCalculatorPercentagesCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var pointsRecievedTextField: UITextField!
    @IBOutlet weak var pointsPossibleTextField: UITextField!
    @IBOutlet weak var selectCategoryButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

