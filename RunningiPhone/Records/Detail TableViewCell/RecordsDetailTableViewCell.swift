//
//  RecordsDetailTableViewCell.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/19.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit
import Charts

class RecordsDetailTableViewCell: UITableViewCell {
    
    var record: Record?
    
    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension RecordsDetailTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let lineCell = collectionView.dequeueReusableCell(withReuseIdentifier: "lineDetailCollectionCell", for: indexPath) as! LineChartRecordsDetailCollectionViewCell
        
        if let record = self.record {
            switch indexPath.row {
            case 0:  // tibshock
                var data = [ChartDataEntry]()
                
                if let tsRecord = record.tibShock,
                    let tsPosRecord = record.tibShockPos{
                    for i in 0..<tsRecord.count{
                        data.append(ChartDataEntry(x: tsPosRecord[i]-tsPosRecord[0], y: tsRecord[i]))
                    }
                }
                
                lineCell.inputEntry = data
                lineCell.titleLabel.text = lineCell.titleLabel.text == "Tibial Shock" ? "Tibial Shock " : "Tibial Shock"
                
            case 1: // Cadence
                var data = [ChartDataEntry]()
                
                if let cadence = record.cadence{
                    for i in 0..<cadence.count {
                        data.append(ChartDataEntry(x: Double(i), y: Double(cadence[i])))
                    }
                }
                
                lineCell.inputEntry = data
                lineCell.titleLabel.text = lineCell.titleLabel.text == "Cadence" ? "Cadence " : "Cadence"
                
            default:
                break
            }
        }
        
        return lineCell
    }
    
    
}
