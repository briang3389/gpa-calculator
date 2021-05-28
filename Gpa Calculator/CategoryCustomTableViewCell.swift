//
//  CategoryCustomTableViewCell.swift
//  Gpa Calculator
//
//  Created by Brian on 5/16/20.
//  Copyright © 2020 Brian. All rights reserved.
//

import UIKit

class CategoryCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
