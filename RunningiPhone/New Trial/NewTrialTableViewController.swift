//
//  NewTrialViewController.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/19.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit
import CoreBluetooth
import MBProgressHUD

class NewTrialTableViewController: UITableViewController{
    
    var trialType: String?
    
    var connectedPeripheral = [CBPeripheral]()
    var savedCharacteristic: CBCharacteristic!
    
    var devices = [CBPeripheral]()
    var deviceInfo = [NSMutableDictionary]()
    
    var deviceType = 0
    var connectTimer: Timer = Timer()
    
    var disconnectedPeripheral: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        SensorManager.shared.delegate = self
        
        for peripheral in connectedPeripheral {
            SensorManager.shared.disconnectPeripheral(peripheral: peripheral)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let type = self.trialType{
            switch type {
            case "baseline":
                navigationItem.title = "Baseline Test"
            case "new":
                navigationItem.title = "New Trial"
            default:
                break
            }
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshBtnPressed))
    }
    
    @objc func refreshBtnPressed() {
        self.startScanning()
    }
    
    @objc func startScanning() {
        Timer.cancelPreviousPerformRequests(withTarget: self, selector: #selector(stopScanning), object: nil)
        stopScanning()
        
        if connectTimer.isValid {
            connectTimer.invalidate()
            SensorManager.shared.disconnectDevice()
        }
        
        devices = [CBPeripheral]()
        deviceInfo = [NSMutableDictionary]()
        self.tableView.reloadData()
        
        SensorManager.shared.startScanning()
        self.perform(#selector(stopScanning), with: nil, afterDelay: 10)
    }
    
    @objc func stopScanning() {
        SensorManager.shared.stopScanning()
    }
    
    
    // MARK: - Table View Functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Sensor Connection"
        default: return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            if devices.count == 0{
                return "No sensor found. Tap top-right button to refresh."
            } else {
                return "Tap to connect."
            }
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return devices.count
        default:
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "IoT Sensor: " +  String(devices[indexPath.row].identifier.uuidString.suffix(4))
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section{
        case 0:
            _ = MBProgressHUD.showAdded(to: self.view, animated: true)
            
            SensorManager.shared.stopScanning()
            let peripheral: CBPeripheral = self.devices[indexPath.row]
            SensorManager.shared.connectToPeripheral(peripheral: peripheral)
            if (peripheral.name?.contains("WRBL"))! {
                deviceType = 1
            } else if (peripheral.name?.contains("IoT"))! {
                deviceType = 0
            }
            
            break
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toTrialSegue":
            let newVC = segue.destination as! TrialViewController
            newVC.type = sender as? String
        default:
            break
        }
    }
}

extension NewTrialTableViewController: SensorManagerDelegate{

    func didUpdateState(state: CBManagerState) {
        func didUpdateState(state: CBManagerState) {
            switch state {
            case CBManagerState.poweredOn:
                self.startScanning()
                break
            case CBManagerState.unknown: break
            case CBManagerState.resetting: break
            case CBManagerState.unsupported: break
            case CBManagerState.unauthorized: break
            case CBManagerState.poweredOff: break
            default: break
                
            }
        }
    }
    
    func didDiscoverPeripheral (peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if ((advertisementData["kCBAdvDataManufacturerData"] == nil)) {
            return
        }
        
        for p:CBPeripheral in self.devices {
            if p.identifier == peripheral.identifier {
                return
            }
        }
        
        let advData = NSMutableDictionary(dictionary: advertisementData)
        advData["RSSI"] = RSSI
        
        self.devices.append(peripheral)
        self.deviceInfo.append(advData)
        self.tableView.reloadData()
    }
    
    func didConnectPeripheral(peripheral: CBPeripheral) {
        NSLog("Connected \(peripheral.name ?? "Nothing")")
        
        let periController = PeripheralController(peripheral: peripheral)
        peripheral.delegate = periController
        peripheral.discoverServices(nil)
        
        // Global Variables
        g_peripheral = peripheral
        g_periController = periController
        
        // UI
        connectedPeripheral.append(peripheral)
        self.startScanning()
        
        _ = MBProgressHUD.hide(for: self.view, animated: true)
        
        let type = self.trialType
        performSegue(withIdentifier: "toTrialSegue", sender: type)
    }
    
    func didFailToConnectPeripheral(peripheral: CBPeripheral) {
        _ = MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func didDisconnectPeripheral(peripheral: CBPeripheral) {
        print("did disconnect")
    }
    
    
}
