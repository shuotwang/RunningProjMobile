//
//  PeripheralController.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/22.
//  Copyright © 2019 Vincent. All rights reserved.
//

import Foundation
import CoreBluetooth

class PeripheralController: NSObject, CBPeripheralDelegate {
    
    var magnetometerSensorStatus: UInt8 = 0
    var magnetometerCalibrationState: UInt8 = 0
    var sensorVersion = ""
    var deviceType: UInt8 = 0
    var iotNewFirmware = false
    
    var peripheral: CBPeripheral?
    var started = false
    var oneShotModeSelected = false
    var oneShotMode = false
    var sensorFusionEnabled = false
    var gyroscopeRate = 10.0
    var gyroscopeSensitivity = 16.4
    var accelerometerSensitivity = 2048.0

//    var sensorDataManager: SensorDataManager?
    
    let GYROSCOPE_SENSITIVITY = [16.4, 32.8, 65.6, 131.2, 262.4]
    let GYROSCOPE_RATES = [0.78, 1.56, 3.12, 6.25, 12.5, 25.0, 50.0, 100.0]
    let SENSOR_FUSION_RATES_680 = [0.78, 1.56, 3.12, 6.25, 12.5, 25, 50]
    
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
//        sensorDataManager = SensorDataManager(peripheral: peripheral)
    }
    
    func discoverService() {
        iotNewFirmware = false
        self.started = false
        self.oneShotModeSelected = false
        self.oneShotMode = false
        self.sensorFusionEnabled = false
        self.accelerometerSensitivity = 2048
        self.gyroscopeRate = 10
        self.gyroscopeSensitivity = 16.4
//        self.peripheral!.discoverServices(nil)
    }
    
    func stopListeners() {
        for service: CBService in (self.peripheral?.services!)! {
            for characteristic: CBCharacteristic in service.characteristics! {
                self.peripheral!.setNotifyValue(false, for: characteristic)
            }
        }
    }
    
    func writeValueWithResponse(serviceUUID: CBUUID, characteristicUUID: CBUUID, data: NSData) {
        self.writeValue(serviceUUID: serviceUUID, characteristicUUID: characteristicUUID, data: data, responseType: CBCharacteristicWriteType.withResponse)
    }
    
    func writeValueWithoutResponse(serviceUUID: CBUUID, characteristicUUID: CBUUID, data: NSData) {
        self.writeValue(serviceUUID: serviceUUID, characteristicUUID: characteristicUUID, data: data, responseType: CBCharacteristicWriteType.withoutResponse)
    }
    
    func writeValue(serviceUUID: CBUUID, characteristicUUID: CBUUID, data: NSData, responseType: CBCharacteristicWriteType) {
        let service = self.findServiceWithUUID(UUID: serviceUUID)
        if service == nil {
            NSLog("Could not find service (Write) with UUID \( serviceUUID.uuidString)")
            return
        }
        
        let characteristic = self.findCharacteristicWithUUID(UUID: characteristicUUID, service: service!)
        if characteristic == nil {
            NSLog("Could not find characteristic with UUID \(characteristicUUID.uuidString)")
            return
        }
        
        self.peripheral!.writeValue(data as Data, for: characteristic!, type: responseType)
    }
    
    func readValue(serviceUUID: CBUUID, characteristicUUID: CBUUID) {
        let service = self.findServiceWithUUID(UUID: serviceUUID)
        if service == nil {
            NSLog("Could not find service (Read) with UUID \(serviceUUID.uuidString)")
            return
        }
        
        let characteristic = self.findCharacteristicWithUUID(UUID: characteristicUUID, service: service!)
        if characteristic == nil {
            NSLog("Could not find characteristic with UUID \(characteristicUUID.uuidString)")
            return
        }
        
        self.peripheral!.readValue(for: characteristic!)
        
    }
    
    func findServiceWithUUID(UUID: CBUUID) -> CBService? {
        
        if let periService = self.peripheral?.services{
            for service: CBService in periService {
                if service.uuid.uuidString.lowercased() == UUID.uuidString.lowercased() {
                    return service
                }
            }
        
        }
        return nil
}
    
    func findCharacteristicWithUUID(UUID: CBUUID, service: CBService) -> CBCharacteristic? {
        for characteristic: CBCharacteristic in service.characteristics! {
            if characteristic.uuid.uuidString.lowercased() == UUID.uuidString.lowercased() {
                return characteristic
            }
        }
        return nil
    }
    
    // MARK: Sensor Commands
    func sendConfigCommand(command: UInt8) {
        var theData = command
        let data = NSData(bytes: &theData, length: 1)
        writeValueWithResponse(serviceUUID: CBUUID.init(string: DIALOG_WEARABLES_SERVICE), characteristicUUID: CBUUID.init(string: DIALOG_WEARABLES_CHARACTERISTIC_CONTROL), data: data)
    }
    
    // MARK: CBPeripheralDelegate
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        let wearablesUUID: CBUUID = CBUUID.init(string: DIALOG_WEARABLES_SERVICE)
        
        for service: CBService in peripheral.services! {
            if service.uuid == wearablesUUID {
                NSLog("Wearables Service Found \(peripheral) \(service)")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        NSLog("Characteristics found: %@", service.characteristics ?? "NOTHING")
        
        if service.uuid.uuidString.lowercased() == DIALOG_WEARABLES_SERVICE {
            let characteristicListeners: NSArray = [DIALOG_WEARABLES_CHARACTERISTIC_ACCELEROMETER, DIALOG_WEARABLES_CHARACTERISTIC_GYROSCOPE, DIALOG_WEARABLES_CHARACTERISTIC_TEMPERATURE, DIALOG_WEARABLES_CHARACTERISTIC_BAROMETER, DIALOG_WEARABLES_CHARACTERISTIC_HUMIDITY, DIALOG_WEARABLES_CHARACTERISTIC_MAGNETOMETER, DIALOG_WEARABLES_CHARACTERISTIC_SENSOR_FUSION, DIALOG_WEARABLES_CHARACTERISTIC_CONTROL_NOTIFY]
            
            for characteristic: CBCharacteristic in service.characteristics! {
                if characteristicListeners.contains(characteristic.uuid.uuidString.lowercased()) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SensorControllerServiceDiscovered), object: service, userInfo: nil)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        switch characteristic.uuid.uuidString.lowercased() {
        case DIALOG_WEARABLES_CHARACTERISTIC_MAGNETOMETER:
            // MARK: following two commands may not correct
            var magnetometerSensorStatus = [UInt8](repeating: 0, count: 1)
            characteristic.value?.copyBytes(to: &magnetometerSensorStatus, from: 1..<2)
            
            let magnetometerCalibrationState = (((characteristic.value?.subdata(in: Range(2...3)))))
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SensorMagnetometerSensorStatusUpdated), object: magnetometerSensorStatus, userInfo: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SensorMagnetometerCalibrationStatusUpdated), object: magnetometerCalibrationState, userInfo: nil)
            
        case DIALOG_WEARABLES_CHARACTERISTIC_FEATURES:
            var version = [UInt8](repeating: 0, count: 17)
            deviceType = 0
            
            characteristic.value?.copyBytes(to: &version, from: 7..<7+16)
            sensorVersion = String(format: "%@", version)
            
            if characteristic.value!.count > 23 {
                characteristic.value?.copyBytes(to: &deviceType, from: 23..<24)
            }
            
            if deviceType > 1 {
                deviceType = 0
            }
            if deviceType == 0 {
                iotNewFirmware = self.meetRequiredVersion(requiredVersion: "5.160.1.20")
                NSLog("IoT dongle firmware: %@", iotNewFirmware ? "new" : "old")
            }
            
            var s_fusion_en: UInt8 = 0
            characteristic.value?.copyBytes(to: &s_fusion_en, from: 6..<7)
            self.sensorFusionEnabled = s_fusion_en > 0
            
        case DIALOG_WEARABLES_CHARACTERISTIC_CONTROL_NOTIFY:
            let data: Data = characteristic.value!
            var command: UInt8 = 0
            
            data.copyBytes(to: &command, from: 1..<2)
            
            switch Int32(command){
            case DIALOG_WEARABLES_COMMAND_CONFIGURATION_START: break
            case DIALOG_WEARABLES_COMMAND_CONFIGURATION_STOP: break
            case DIALOG_WEARABLES_COMMAND_CONFIGURATION_RUNNING_STATE: break
            case DIALOG_WEARABLES_COMMAND_CONFIGURATION_READ: break
            default: break
            }
            
        case DIALOG_WEARABLES_CHARACTERISTIC_ACCELEROMETER:
            
            sensorDataManager?.parseData(sensorType: "ACC", data: characteristic.value!)
//            sensorDataManager!.parseAccData(data: characteristic.value!)
            
        case DIALOG_WEARABLES_CHARACTERISTIC_GYROSCOPE:
            sensorDataManager?.parseData(sensorType: "GYR", data: characteristic.value!)
//            sensorDataManager!.parseGyrData(data: characteristic.value!)
            
        case DIALOG_WEARABLES_CHARACTERISTIC_TEMPERATURE:
            break
        case DIALOG_WEARABLES_CHARACTERISTIC_BAROMETER:
            break
        case DIALOG_WEARABLES_CHARACTERISTIC_HUMIDITY:
            break
        case DIALOG_WEARABLES_CHARACTERISTIC_MAGNETOMETER:
            break
        case DIALOG_WEARABLES_CHARACTERISTIC_CONTROL_NOTIFY:
            break
        case DIALOG_WEARABLES_CHARACTERISTIC_FEATURES:
            break
        case DIALOG_WEARABLES_CHARACTERISTIC_CONTROL_NOTIFY:
            break
        default:
            break
        }
        
//        print("periController", peripheral, characteristic.uuid.uuidString ,characteristic.value!)
        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SensorControllerCharacteristicValueUpdated), object: characteristic, userInfo: nil)
    }
    
    func isIoTNewVersion() -> Bool {
        return deviceType == 1 || iotNewFirmware
    }
    
    func meetRequiredVersion(requiredVersion: String) -> Bool {
        return requiredVersion.compare(sensorVersion, options: .numeric) != .orderedDescending
    }
    
    func getDeviceType() -> UInt8{
        return deviceType
    }
    
    func setDeviceType(type: UInt8) {
        deviceType = type
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        NSLog("Peripheral %@ RSSI: \((peripheral.name, RSSI))")
    }

}


extension PeripheralController{
    
    func sensorRead() {
        readValue(serviceUUID: CBUUID.init(string: DIALOG_WEARABLES_SERVICE), characteristicUUID: CBUUID.init(string: DIALOG_WEARABLES_CHARACTERISTIC_FEATURES))
        sendConfigCommand(command: UInt8(DIALOG_WEARABLES_COMMAND_CONFIGURATION_READ))
        sendConfigCommand(command: UInt8(DIALOG_WEARABLES_COMMAND_CONFIGURATION_RUNNING_STATE))
    }
    
    func startSensorRead() {
        NSLog("Start Sensor Read")
        sendConfigCommand(command: UInt8(DIALOG_WEARABLES_COMMAND_CONFIGURATION_START))
    }
    
    func stopSensorRead() {
        NSLog("Stop Sensor Read")
        sendConfigCommand(command: UInt8(DIALOG_WEARABLES_COMMAND_CONFIGURATION_STOP))
    }
    
    func doConfig() {
        let data = NSMutableData()

        let bytes: [UInt8] = [UInt8(DIALOG_WEARABLES_COMMAND_CONFIGURATION_WRITE),
            3, //byte_sensor_combination
            0x0C, //byte_accelerometer_range,
            0x09, //byte_accelerometer_rate, 0x09 for 200Hz
            0x00, //byte_gyroscope_range,
            0x09, //byte_gyroscope_rate,
            0x01, //byte_magnetometer_rate,
            1, //byte_environment_rate,
            0, //sensorFusionActive ? byte_sensor_fusion_rate : 0,
            0, //byte_sensor_fusion_raw_enabled,
            0, //byte_calibration_mode,
            0  //byte_auto_calibration_mode
        ]

        data.append(bytes, length: MemoryLayout.size(ofValue: bytes))
        writeValueWithResponse(serviceUUID: CBUUID.init(string: DIALOG_WEARABLES_SERVICE), characteristicUUID:CBUUID.init(string: DIALOG_WEARABLES_CHARACTERISTIC_CONTROL), data: data)

        NSLog("Sensor Config Data Successfully Written!");
    }
    
    
}
