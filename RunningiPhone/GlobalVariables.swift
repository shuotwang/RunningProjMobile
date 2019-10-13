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
var g_isAudioOn: Bool = true
var g_isConnected: Bool = false

let darkDarkGray = UIColor(red: 31/255, green: 33/255, blue: 36/255, alpha: 1)

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

extension String {
    var findNumber: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars
            .flatMap { pattern ~= $0 ? Character($0) : nil })
    }
}
