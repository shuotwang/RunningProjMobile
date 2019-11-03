//
//  DataCollector.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/22.
//  Copyright © 2019 Vincent. All rights reserved.
//

import Foundation

class DataCollector {
    
    static let shared = DataCollector()
    
    var timer = Timer()
    
    var accTimeStamp = [Double]()
    var accXs = [Double]()
    var accYs = [Double]()
    var accZs = [Double]()
    
    var gyrTimeStamp = [Double]()
    var gyrXs = [Double]()
    var gyrYs = [Double]()
    var gyrZs = [Double]()
    
    public func receiveAccData(data: AccData){
        // Collect x axis data into an array
        accTimeStamp.append(data.milliStamp)
        accXs.append(data.accX)
        accYs.append(data.accY)
        accZs.append(data.accZ)
        
        if accTimeStamp.count > 2000 || accXs.count > 2000 || accYs.count > 2000 || accZs.count > 2000{
            accTimeStamp = [Double]()
            accXs = [Double]()
            accYs = [Double]()
            accZs = [Double]()
        }
        
    }
    
    public func receiveGyrData(data: GyrData){
        gyrTimeStamp.append(data.milliStamp)
        gyrXs.append(data.gyrX)
        gyrYs.append(data.gyrY)
        gyrZs.append(data.gyrZ)
        
        if gyrTimeStamp.count > 2000 || gyrXs.count > 2000 || gyrYs.count > 2000 || gyrZs.count > 2000 {
            gyrTimeStamp = [Double]()
            gyrXs = [Double]()
            gyrYs = [Double]()
            gyrZs = [Double]()
        }
    }
    
    func startSensorRead() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction() {
        if accTimeStamp.count > 0 && accXs.count > 0 && accYs.count > 0 && accZs.count > 0 {
            passAccToCal(accTimeStamp: accTimeStamp, accXs: accXs, accYs: accYs, accZs: accZs)
            accTimeStamp = [Double]()
            accXs = [Double]()
            accYs = [Double]()
            accZs = [Double]()
        }
        
        if g_gyrIsOn {
            if gyrTimeStamp.count > 0 && gyrXs.count > 0 && gyrYs.count > 0 && gyrZs.count > 0 {
                passGyrToCal(gyrTimeStamp: gyrTimeStamp, gyrXs: gyrXs, gyrYs: gyrYs, gyrZs: gyrZs)
                gyrTimeStamp = [Double]()
                gyrXs = [Double]()
                gyrYs = [Double]()
                gyrZs = [Double]()
            }
        }
    }
    
    func stopSensorRead() {
        timer.invalidate()
        accTimeStamp = [Double]()
        accXs = [Double]()
        accYs = [Double]()
        accZs = [Double]()
        
        gyrTimeStamp = [Double]()
        gyrXs = [Double]()
        gyrYs = [Double]()
        gyrZs = [Double]()
    }
    
    func passAccToCal(accTimeStamp: [Double], accXs: [Double], accYs: [Double], accZs: [Double]){
        DataCalculator.shared.receiveAccData(accTimeStamp: accTimeStamp, accXs: accXs, accYs: accYs, accZs: accZs)
    }
    
    func passGyrToCal(gyrTimeStamp: [Double], gyrXs: [Double], gyrYs: [Double], gyrZs: [Double]){
        DataCalculator.shared.receiveGyrData(gyrTimeStamp: gyrTimeStamp, gyrXs: gyrXs, gyrYs: gyrYs, gyrZs: gyrZs)
    }
}
