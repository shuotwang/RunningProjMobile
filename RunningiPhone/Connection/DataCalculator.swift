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
    
    var dataCalculatorDelegate: DataCalculatorDelegate?
    
    func receiveAccData(accTimeStamp: [Double], accXs: [Double], accYs: [Double], accZs: [Double]) {
        
        var duration = Double()
        if accTimeStamp.count > 0{
            duration = accTimeStamp[accTimeStamp.count - 1] - accTimeStamp[0]
        }
        
        let dataRate = Double(accXs.count) / duration
        
        let (tsRecord, tsPosRecord) = calTsPerSec(timeStamps: accTimeStamp, data: accXs, dataRate: dataRate)
        
        calAveTsCad(tsRecord: tsRecord, tsPosRecord: tsPosRecord)
        
        // save data every time this func is called
        DataSaver.shared.saveData(accTimeStamp: accTimeStamp, tsRecord: tsRecord, tsPosRecord: tsPosRecord, accXs: accXs, accYs: accYs, accZs: accZs)
    }
    
    func receiveGyrData(gyrTimeStamp: [Double], gyrXs: [Double], gyrYs: [Double], gyrZs: [Double]) {
        DataSaver.shared.saveDataWithGyr(gyrTimeStamp: gyrTimeStamp, gyrXs: gyrXs, gyrYs: gyrYs, gyrZs: gyrZs)
    }
    
    func calTsPerSec(timeStamps: [Double], data: [Double], dataRate: Double) -> ([Double], [Double]) {
        var tsRecord = [Double]()
        var tsPosRecord = [Double]()

        let tibShockPos = FindPeak.getTibShock(data: data, dataRate: dataRate)
        let tibShocks = tibShockPos.map { data[$0] }
        
        // tibShock
        if tibShockPos.count > 0 {
            for i in 0..<tibShockPos.count{
                let idx = tibShockPos[i]
                tsPosRecord.append(timeStamps[idx])
                tsRecord.append(tibShocks[i])
            }
        }
        return (tsRecord, tsPosRecord)
    }
    
    
    
    
    var tsRecord1 = [Double]()
    var tsRecord2 = [Double]()
    var tsPosRecord1 = [Double]()
    var tsPosRecord2 = [Double]()
    
    func calAveTsCad(tsRecord: [Double], tsPosRecord: [Double]){
        var currentTsRecord = [Double]()
        currentTsRecord.append(contentsOf: tsRecord1)
        currentTsRecord.append(contentsOf: tsRecord2)
        currentTsRecord.append(contentsOf: tsRecord)
        
        var currentTsPosRecord = [Double]()
        currentTsPosRecord.append(contentsOf: tsPosRecord1)
        currentTsPosRecord.append(contentsOf: tsPosRecord2)
        currentTsPosRecord.append(contentsOf: tsPosRecord)
        
        // Tibial Shock (per second)
        let aveTs = Surge.sum(tsRecord) / Double(tsRecord.count)
        
        // Cadence (per 3 seconds)
        var cadence = 0
        
        if currentTsPosRecord.count > 0 {
            let dur = currentTsPosRecord[currentTsPosRecord.count - 1] - currentTsPosRecord[0]
            
            let cad = Double(currentTsRecord.count - 1) * 60 / dur * 2
            
            if !cad.isNaN && !cad.isInfinite{
                cadence = Int(cad)
            }
        }
        
        // Update buffer
        tsRecord1 = tsRecord2
        tsRecord2 = tsRecord
        
        tsPosRecord1 = tsPosRecord2
        tsPosRecord2 = tsPosRecord
        
        // Pass data to ui
        dataCalculatorDelegate?.passTsCad(tibShock: aveTs, cadence: cadence)
        
        // Save Cadence Data
        DataSaver.shared.saveCad(cadRecord: cadence)
    }
    
    func calTsThres(tsRecord: [Double]) -> Double{
        return Double(Surge.sum(tsRecord)/Double(tsRecord.count))
    }
}
