//
//  GlobalVariables.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/21.
//  Copyright © 2019 Vincent. All rights reserved.
//

import Foundation
import CoreBluetooth


var g_currentUser: User?
var g_gyrIsOn: Bool = true
var g_peripheral: CBPeripheral?
var g_periController: PeripheralController?
var g_startingTime: Date?

struct AccData {
    var milliStamp: Double
    var accX: Double
    var accY: Double
    var accZ: Double
}

struct GyrData{
    var milliStamp: Double
    var gyrX: Double
    var gyrY: Double
    var gyrZ: Double
}

// Sensor Connection
let SensorControllerServiceDiscovered: String = "SensorControllerServiceDiscovered"
let SensorControllerCharacteristicValueUpdated: String = "SensorControllerCharacteristicValueUpdated"
let SensorMagnetometerSensorStatusUpdated: String = "SensorMagnetometerSensorStatusUpdated"
let SensorMagnetometerCalibrationStatusUpdated: String = "SensorMagnetometerCalibrationStatusUpdated"

class GlobalVariables: NSObject{
    static func data2Int16(data: Data) -> Int16{
        
        let data = data as NSData
        var x: Int16 = 0
        data.getBytes(&x, range: NSRange(location: 0, length: 2))
        return x
    }
}

extension Date{
    var milliStamp : Double {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return Double(millisecond)
    }
}
