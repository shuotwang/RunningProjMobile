//
//  RecordsSummaryTableViewCell.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/19.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit

//summaryCollectionCell

class RecordsSummaryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var summaryCollectionView: UICollectionView!
    
//    var summaries:
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension RecordsSummaryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var summaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "summaryCollectionCell", for: indexPath)
        
        return summaryCell
        
    }
    
    
}
