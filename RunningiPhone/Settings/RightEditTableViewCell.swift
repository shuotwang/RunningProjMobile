//
//  RightEditTableViewCell.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/19.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit

class RightEditTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightTextField: UITextField!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        rightTextField.borderStyle = .none
        rightTextField.font = .systemFont(ofSize: 17)
        rightTextField.keyboardType = .decimalPad
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
