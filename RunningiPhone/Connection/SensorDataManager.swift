//
//  SensorDataManager.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/22.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit
import CoreBluetooth

class SensorDataManager: NSObject {
    
    // Every sensor has a SensorDataManager
    
    var accSensitivity = 2048.0
    var gyroscopeRate = 200.0
    var gyrSensitivity = 16.4
    
    var number = 0
    var gyrNumber = 0

    var peripheral: CBPeripheral!
//    var imuData: ImuData?
    
    var acc = [Double]()
    var gyr = [Double]()
    
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
    }
    
    func parseData(sensorType: String, data: Data) {
        
        var reportID: UInt8 = 0
        var sensorState: UInt8 = 0
        var sensorEvent: UInt8 = 0
        data.copyBytes(to: &reportID, from: 0..<1)
        data.copyBytes(to: &sensorState, from: 1..<2)
        data.copyBytes(to: &sensorEvent, from: 2..<3)
        
        let x = GlobalVariables.data2Int16(data: data.subdata(in: 3..<5))
        let y = GlobalVariables.data2Int16(data: data.subdata(in: 5..<7))
        let z = GlobalVariables.data2Int16(data: data.subdata(in: 7..<9))
        
        if sensorType == "ACC" {
            let valueX = Double(y) / self.accSensitivity
            let valueY = -Double(x) / self.accSensitivity
            let valueZ = Double(z) / self.accSensitivity
            
            let accData = AccData(milliStamp: Date().timeIntervalSince1970, accX: valueX, accY: valueY, accZ: valueZ)
            DataCollector.shared.receiveAccData(data: accData)

        } else if sensorType == "GYR" {
            let valueX = Double(y) / self.gyrSensitivity
            let valueY = -Double(x) / self.gyrSensitivity
            let valueZ = Double(z) / self.gyrSensitivity
            
            if g_gyrIsOn{
                let gyrData = GyrData(milliStamp: Date().timeIntervalSince1970, gyrX: valueX, gyrY: valueY, gyrZ: valueZ)
                DataCollector.shared.receiveGyrData(data: gyrData)
            }
        }
        
//        if acc.count == 3 && gyr.count == 3 {
//            let imuData = ImuData(milliStamp: Date().milliStamp, device: String(peripheral.identifier.uuidString.suffix(4)), acc: acc, gyr: gyr)
//            acc = []
//            gyr = []
//
//            CentralDataCollector.shared.receiveData(imuData: imuData)
//        }
        
//    NSLog("\(Date().milliStamp)\t\(peripheral.identifier.uuidString.suffix(4))\t%8.2fg %8.2fg %8.2fg %8.2fd %8.2fd %8.2fd %8.d", acc[0], acc[1], acc[2], gyr[0], gyr[1], gyr[2])

        
    }
            
}

