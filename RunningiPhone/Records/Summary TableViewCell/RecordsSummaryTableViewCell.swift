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
    
    var records = [Record]()
    
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var summaryCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dateFormatter.dateFormat = "MMM dd, yyyy HH:mm"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension RecordsSummaryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return records.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentRecord = records[records.count - 1 - indexPath.row]
        
        let summaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "summaryCollectionCell", for: indexPath) as! RecordsSummaryCollectionViewCell
        summaryCell.dateLabel.text = dateFormatter.string(from: currentRecord.time!)
        summaryCell.durationLabel.text = "\(currentRecord.duration/60):\(currentRecord.duration%60)"
        if currentRecord.type == "baseline"{
            summaryCell.typeLabel.text = "Baseline Test"
        }else{
            summaryCell.typeLabel.text = "Training Trial"
        }
        
        return summaryCell
        
    }
    
    
}
