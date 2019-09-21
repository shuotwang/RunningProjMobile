//
//  LineChartRecordsDetailCollectionViewCell.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/20.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit
import Charts

class LineChartRecordsDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    
    var dataEntry = [ChartDataEntry]()
    
    var inputEntry: [ChartDataEntry]?
    
    override func layoutSubviews() {
        
        dataEntry = [ChartDataEntry]()
        
        //        for index in 0...inputData.count - 1{
        //            let item  = inputData[index]
        //            if !item.isNaN && !item.isInfinite {
        //                let entry = ChartDataEntry(x: Double(index), y: item)
        //                dataEntry.append(entry)
        //            }
        //        }
        if let input = inputEntry{
            dataEntry = input
        }
        
        // Animation
        lineChartView.animate(xAxisDuration: 0.7)
        
        updateChart()
    }
    
    override func awakeFromNib() {
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        
        // Set diagram UI
        lineChartView.rightAxis.enabled = false
        
        // Back ground
        lineChartView.drawGridBackgroundEnabled = true
        
        // Legend
        //        lineChartView.legend.textColor = .lightGray
        //        lineChartView.legend.font = UIFont.systemFont(ofSize: 10, weight: .light)
        lineChartView.legend.enabled = false
        
        // Axis Value Color
        lineChartView.leftAxis.labelTextColor = .lightGray
        lineChartView.xAxis.labelTextColor = .lightGray
        
        // Disable Zoom
        lineChartView.scaleXEnabled = false
        lineChartView.scaleYEnabled = false
        
        
        
    }
    
    private func updateChart() {
        let chartDataSet = LineChartDataSet(entries: dataEntry, label: nil)
        
        // Line Width
        chartDataSet.lineWidth = 2
        chartDataSet.colors = [.cyan]
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.drawCircleHoleEnabled = false
        chartDataSet.drawFilledEnabled = true
        chartDataSet.fillColor = .cyan
        
        let chartData = LineChartData(dataSet: chartDataSet)
        chartData.setValueFont(UIFont.systemFont(ofSize: 8, weight: .light))
        chartData.setValueTextColor(.lightGray)
        
        lineChartView.data = chartData
    }
}
