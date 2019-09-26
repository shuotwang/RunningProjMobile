//
//  RecordsSummaryTableViewCell.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/19.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit

protocol RecordsSummaryDelegate {
    func passRecordIdx(index: Int)
}

class RecordsSummaryTableViewCell: UITableViewCell {
    
    var records = [Record]()
    
    let dateFormatter = DateFormatter()
    
    var selectedIndexPath = IndexPath()
    
    var recordsSummaryDelegate: RecordsSummaryDelegate?
    
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
        summaryCell.durationLabel.text = String(format: "%02d", currentRecord.duration/60) + ":" + String(format:"%02d", currentRecord.duration%60)
        if currentRecord.type == "baseline"{
            summaryCell.typeLabel.text = "Baseline Test"
        }else{
            summaryCell.typeLabel.text = "Training Trial"
        }
        
        if indexPath == self.selectedIndexPath {
            summaryCell.brightenView()
        }else {
            summaryCell.dimView()
        }
        
        return summaryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedIndexPath = indexPath
        collectionView.reloadData()
        
        recordsSummaryDelegate?.passRecordIdx(index: records.count - 1 - indexPath.row)
    }
    
    
}
