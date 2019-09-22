//
//  SensorManager.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/22.
//  Copyright © 2019 Vincent. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol SensorManagerDelegate: NSObject {
    var disconnectedPeripheral: String {get set}
    
    func didUpdateState(state: CBManagerState)
    func didDiscoverPeripheral(peripheral: CBPeripheral, advertisementData:[String: Any], rssi RSSI:NSNumber)
    func didConnectPeripheral(peripheral: CBPeripheral)
    func didFailToConnectPeripheral(peripheral: CBPeripheral)
    func didDisconnectPeripheral(peripheral: CBPeripheral)
}

class SensorManager: NSObject, CBCentralManagerDelegate {
    
    let DisconnectedPeripheral = "DisconnectedPeripheral"
    
    static let shared = SensorManager()
    var delegate: SensorManagerDelegate? // SensorSelectionViewController
    var device: CBPeripheral?
    
    var devices = [CBPeripheral]()
    
    var centralManager: CBCentralManager!
    
    override init() {
        super.init()
        centralManager = CBCentralManager.init(delegate: self, queue: nil)
    }
    
    func startScanning() {
        NSLog("Start Scanning")
        centralManager.scanForPeripherals(withServices: [CBUUID (string: "2ea7")], options: nil)
    }
    
    func stopScanning() {
        NSLog("Stop Scanning")
        centralManager.stopScan()
    }
    
    func connectToPeripheral(peripheral: CBPeripheral) {
        self.device = peripheral
        centralManager.connect(peripheral, options: nil)
    }
    
    func disconnectPeripheral(peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
    func disconnectDevice() {
        if (self.device == nil || (self.device?.state != CBPeripheralState.connected && self.device?.state != CBPeripheralState.connecting)) {
            return
        }
        centralManager.cancelPeripheralConnection(self.device!)
        self.device = nil
    }
    
    // MARK: CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        var state = ""
        
        switch central.state {
        case .unknown:
            state = "Unknown"
        case .resetting:
            state = "Resetting"
        case .unsupported:
            state = "Unsupported" // not support bluetooth
        case .unauthorized:
            state = "Unauthorized"
        case .poweredOff:
            state = "PoweredOff" // bluetooth off
        case .poweredOn:
            state = "PoweredOn" // bluetooth on
        }
        NSLog("Bluetooth state changed to \(state), \(central.state.rawValue)")
        self.delegate?.didUpdateState(state: central.state)
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        NSLog("Discovered %@ at %@", String(peripheral.name!), advertisementData);
        
        self.delegate?.didDiscoverPeripheral(peripheral: peripheral, advertisementData: advertisementData, rssi: RSSI)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            self.delegate?.didConnectPeripheral(peripheral: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        NSLog("Disconnect from device: %@", String(peripheral.name!))
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DisconnectedPeripheral), object: nil, userInfo: nil)
        self.delegate?.didDisconnectPeripheral(peripheral: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        self.delegate?.didFailToConnectPeripheral(peripheral: peripheral)
        
    }
    
}
