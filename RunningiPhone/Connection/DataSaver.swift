//
//  DataSaver.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/23.
//  Copyright © 2019 Vincent. All rights reserved.
//

import Foundation

class DataSaver {
    
    static let shared = DataSaver()
    
    var tsRecord = [[Double: Double]]() // [milliSecTimeStamp: tibShock]
    var cadRecord = [Int]()  // every second one cadence
    
    var accXs = [Double]()
    var accYs = [Double]()
    var accZs = [Double]()
    
    var gyrXs = [Double]()
    var gyrYs = [Double]()
    var gyrZs = [Double]()
    
    func saveData(accTimeStamp:[Double], tsRecord: [[Double: Double]], cadRecord: [Int], accXs: [Double], accYs: [Double], accZs: [Double]) {
        self.tsRecord.append(contentsOf: tsRecord)
        self.cadRecord.append(contentsOf: cadRecord)
        self.accXs.append(contentsOf: accXs)
        self.accYs.append(contentsOf: accYs)
        self.accZs.append(contentsOf: accZs)
    }
    
    func saveDataWithGyr(gyrTimeStamp: [Double], gyrXs: [Double], gyrYs: [Double], gyrZs: [Double]) {
        self.gyrXs.append(contentsOf: gyrXs)
        self.gyrYs.append(contentsOf: gyrYs)
        self.gyrZs.append(contentsOf: gyrZs)
    }
    
    func doFinalSave(userNum: Int64, recordNum: Int64, time: Date, duration: Int64, type: String) {
        CoreDataHelper.shared.createRecordWith(userNum: userNum,
                                               recordNum: recordNum,
                                               time: time,
                                               duration: duration,
                                               type: type,
                                               accX: accXs,
                                               accY: accYs,
                                               accZ: accZs,
                                               gyrX: gyrXs,
                                               gyrY: gyrYs,
                                               gyrZ: gyrZs,
                                               tibShock: tsRecord)
        
        tsRecord = [[Double: Double]]()
        cadRecord = [Int]()
        
        accXs = [Double]()
        accYs = [Double]()
        accZs = [Double]()
        
        gyrXs = [Double]()
        gyrYs = [Double]()
        gyrZs = [Double]()
    }
    
}
