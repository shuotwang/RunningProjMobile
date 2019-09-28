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
    
    var accTimeStamp = [Double]()
    var tsPosRecord = [Double]() // [milliSecTimeStamp]
    var tsRecord = [Double]() // [tibShock]
    var cadRecord = [Int]()  // every second one cadence
    
    var accXs = [Double]()
    var accYs = [Double]()
    var accZs = [Double]()
    
    var gyrTimeStamp = [Double]()
    var gyrXs = [Double]()
    var gyrYs = [Double]()
    var gyrZs = [Double]()
    
    func saveData(accTimeStamp:[Double], tsRecord: [Double], tsPosRecord: [Double], accXs: [Double], accYs: [Double], accZs: [Double]) {
        self.accTimeStamp.append(contentsOf: accTimeStamp)
        self.tsRecord.append(contentsOf: tsRecord)
        self.tsPosRecord.append(contentsOf: tsPosRecord)
        self.accXs.append(contentsOf: accXs)
        self.accYs.append(contentsOf: accYs)
        self.accZs.append(contentsOf: accZs)
    }
    
    func saveCad(cadRecord: Int){
        self.cadRecord.append(cadRecord)
    }
    
    func saveDataWithGyr(gyrTimeStamp: [Double], gyrXs: [Double], gyrYs: [Double], gyrZs: [Double]) {
        self.gyrTimeStamp.append(contentsOf: gyrTimeStamp)
        self.gyrXs.append(contentsOf: gyrXs)
        self.gyrYs.append(contentsOf: gyrYs)
        self.gyrZs.append(contentsOf: gyrZs)
    }
    
    func doFinalSave(userNum: Int64, recordNum: Int64, time: Date, duration: Int64, type: String) {
        // 1. Save data to CoreData
        CoreDataHelper.shared.createRecordWith(userNum: userNum,
                                               recordNum: recordNum,
                                               time: time,
                                               duration: duration,
                                               type: type,
                                               accTimeStamp: accTimeStamp,
                                               accX: accXs,
                                               accY: accYs,
                                               accZ: accZs,
                                               gyrTimeStamp: gyrTimeStamp,
                                               gyrX: gyrXs,
                                               gyrY: gyrYs,
                                               gyrZ: gyrZs,
                                               tibShock: tsRecord,
                                               tibShockPos: tsPosRecord,
                                               cadence: cadRecord)
        
        // 2. Cal Ts threshold and save to user default
        print(type)
        if type == "baseline"{
            let tsThres = DataCalculator.shared.calTsThres(tsRecord: tsRecord) * 0.8
            UserDefaults.standard.set(tsThres, forKey: "tsThres")
            CoreDataHelper.shared.updateUserWithNewThres(num: userNum, tsThres: tsThres)
        }
        
        // 3. empty all data buffer
        accTimeStamp = [Double]()
        tsPosRecord = [Double]() // [milliSecTimeStamp]
        tsRecord = [Double]() // [tibShock]
        cadRecord = [Int]()  // every second one cadence
        
        accXs = [Double]()
        accYs = [Double]()
        accZs = [Double]()
        
        gyrTimeStamp = [Double]()
        gyrXs = [Double]()
        gyrYs = [Double]()
        gyrZs = [Double]()
        
    }
    
}
