//
//  RecordsSummaryCollectionViewCell.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/19.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit

class RecordsSummaryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var typeTitle: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func dimView() {
        UIView.animate(withDuration: 0) {
            self.contentView.alpha = 0.4
        }
    }
    
    func brightenView() {
        UIView.animate(withDuration: 0.2) {
            self.contentView.alpha = 1
        }
    }
}
