//
//  DataCalculator.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/22.
//  Copyright © 2019 Vincent. All rights reserved.
//

import Foundation
import Surge

protocol DataCalculatorDelegate {
    func passTsCad(tibShock: Double, cadence: Int)
}

class DataCalculator {
    
    static let shared = DataCalculator()
    
    var accTimeStamp1 = [Double]()
    var accTimeStamp2 = [Double]()
    
    var accXs1 = [Double]()
    var accXs2 = [Double]()
    
    var dataCalculatorDelegate: DataCalculatorDelegate?
    
    func receiveAccData(accTimeStamp: [Double], accXs: [Double], accYs: [Double], accZs: [Double]) {
        
        var currentAccTimeStamp = [Double]()
        currentAccTimeStamp.append(contentsOf: accTimeStamp1)
        currentAccTimeStamp.append(contentsOf: accTimeStamp2)
        currentAccTimeStamp.append(contentsOf: accTimeStamp)
        
        var duration = Double()
        if currentAccTimeStamp.count > 0{
            duration = currentAccTimeStamp[currentAccTimeStamp.count - 1] - currentAccTimeStamp[0]
        }

        var curAccXs = [Double]()
        curAccXs.append(contentsOf: accXs1)
        curAccXs.append(contentsOf: accXs2)
        curAccXs.append(contentsOf: accXs)
        
        let dataRate = Double(curAccXs.count) / duration
        
        let (tibShock, cadence, tsRecord) = calTsCad(timeStamps: currentAccTimeStamp, data: curAccXs, dataRate: dataRate, duration: duration)
        
        accTimeStamp1 = accTimeStamp2
        accTimeStamp2 = accTimeStamp
        
        accXs1 = accXs2
        accXs2 = accXs
        
        dataCalculatorDelegate?.passTsCad(tibShock: tibShock, cadence: cadence)
        
        // save data every time this func is called
        DataSaver.shared.saveData(accTimeStamp: accTimeStamp, tsRecord: tsRecord, cadRecord: [cadence], accXs: accXs, accYs: accYs, accZs: accZs)
    }
    
    func receiveGyrData(gyrTimeStamp: [Double], gyrXs: [Double], gyrYs: [Double], gyrZs: [Double]) {
        DataSaver.shared.saveDataWithGyr(gyrTimeStamp: gyrTimeStamp, gyrXs: gyrXs, gyrYs: gyrYs, gyrZs: gyrZs)
    }
    
    func calTsCad(timeStamps: [Double], data: [Double], dataRate: Double, duration: Double) -> (Double, Int, [[Double: Double]]) {
        
        var tsRecord = [[Double: Double]]()
        
        // Cadence: count the intervals, rather than peaks

        let tibShockPos = FindPeak.getTibShock(data: data, dataRate: dataRate)
        let tibShocks = tibShockPos.map { data[$0] }
        let tibShock = Surge.sum(tibShocks) / Double(tibShocks.count)
        
        var cadence = 0
        
        if tibShockPos.count > 0 {
            let startTime = timeStamps[tibShockPos[0]]
            let endTime = timeStamps[tibShockPos[tibShockPos.count - 1]]
            let dur = endTime - startTime
            
            let cad = Double(tibShocks.count - 1) * 60 / dur * 2
            
            if !cad.isNaN && !cad.isInfinite{
                cadence = Int(cad)
            }
        }
        
        // tibShock Saving
        if tibShockPos.count > 0 {
            for i in 0..<tibShockPos.count{
                let idx = tibShockPos[i]
                let ts = [timeStamps[idx]: tibShocks[i]]
                
                tsRecord.append(ts)
            }
        }

        
        return (tibShock, cadence, tsRecord)
    }

    
    
}
