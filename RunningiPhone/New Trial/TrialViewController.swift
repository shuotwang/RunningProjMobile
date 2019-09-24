//
//  TrialViewController.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/19.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreBluetooth

class TrialViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tibShockLabel: UILabel!
    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var finishBtn: UIButton!
    
    var time = 0
    var isPaused = true
    var isInitial = true
    var type: String?
    
    var startingTime: Date?
    
    var periController: PeripheralController!
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        
        startBtn.setTitle("Start", for: .normal)
        
        self.isInitial = true
        
        if let pc = g_periController{
            self.periController = pc
        }
        
        DataCalculator.shared.dataCalculatorDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isInitial = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.hide(true, afterDelay: 2)

        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
    }
    
    @objc func timerAction() {
        if let periController = g_periController{
            periController.doConfig()
        }
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
}


// MARK: - Control
extension TrialViewController{
    
    @IBAction func startBtnPressed(_ sender: Any) {
        if isInitial{
            self.startingTime = Date()
        }
        
        isPaused = !isPaused
        
        if isPaused{
            startBtn.setTitle("Continue", for: .normal)
            
            timer.invalidate()
            
            periController.stopSensorRead()
            DataCollector.shared.stopSensorRead()
            
        }else {
            startBtn.setTitle("Pause", for: .normal)
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runningTimerAction), userInfo: nil, repeats: true)
            
            periController.startSensorRead()
            DataCollector.shared.startSensorRead()
        }
    }
    
    @objc func runningTimerAction() {
        time = time + 1
        
    }
    
    @IBAction func finishBtnPressed(_ sender: Any) {
        
        timer.invalidate()
        
        let alert = UIAlertController(title: "Save Records?", message: "Are you sure to save record?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            // 1. save
            if let start = self.startingTime,
                let user = g_currentUser,
                let type = self.type{
                let userNum = user.num
                let recordNum = Int64(start.timeIntervalSince1970)
                let startTime = start
                
                DataSaver.shared.doFinalSave(userNum: userNum, recordNum: recordNum, time: startTime, duration: Int64(self.time), type: type)
            }
            
            
            // 2. pop
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            print("Cancelled")
        }))
        
        self.present(alert, animated: true)
        
    }
}

extension TrialViewController: DataCalculatorDelegate{
    func passTsCad(tibShock: Double, cadence: Int) {
        if !tibShock.isNaN && !tibShock.isInfinite {
            self.tibShockLabel.text = String(format: "%.2f", tibShock) + "G"
        }
        
        if cadence != 0 {
            self.cadLabel.text = String(cadence)
        }
    }
    
    
}
