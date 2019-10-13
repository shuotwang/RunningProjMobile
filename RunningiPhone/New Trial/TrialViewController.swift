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
import AVFoundation

class TrialViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tibShockLabel: UILabel!
    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var tibShockThres: UILabel!
    
    var time = 0
    var isPaused = true
    var isInitial = true
    var type: String?
    var player: AVAudioPlayer?
    
    var startingTime: Date?
    
    var periController: PeripheralController!
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SensorManager.shared.sensorManagerToTrialDelegate = self

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.setHidesBackButton(true, animated: true)
        tabBarController?.tabBar.isHidden = true
        
        // TODO: For testing
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self
//            , action: #selector(testingBtnPressed))
        
        startBtn.setTitle("Start", for: .normal)
        
        self.isInitial = true
        
        if let pc = g_periController{
            self.periController = pc
        }
        
        if let type = self.type{
            switch type {
            case "baseline":
                navigationItem.title = "Baseline Test"
            default:
                navigationItem.title = "Training Trial"
                
                if let tsThres = g_currentUser?.tsThres{
                    tibShockThres.text = "Threshold: " + String(format: "%.2f", tsThres) + "G"
                }
            }
        }
        
        g_isConnected = true
        
        DataCalculator.shared.dataCalculatorDelegate = self
    }
    
//    @objc func testingBtnPressed() {
//        self.unexpectedDisconnect()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isInitial = true
        g_isConnected = true
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
        g_isConnected = false
        navigationController?.navigationBar.prefersLargeTitles = true
        tabBarController?.tabBar.isHidden = false
        navigationItem.setHidesBackButton(false, animated: true)
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
        
        let minuteTime = time / 60
        let secondTime = time % 60
        self.timeLabel.text = String(format: "%02d", minuteTime) + ":" + String(format: "%02d", secondTime)
    }
    
    @IBAction func finishBtnPressed(_ sender: Any) {
        
        timer.invalidate()
        periController.stopSensorRead()
        DataCollector.shared.stopSensorRead()
        
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
        
    }
}

extension TrialViewController: DataCalculatorDelegate{
    func passTsCad(tibShock: Double, cadence: Int) {
        if !tibShock.isNaN && !tibShock.isInfinite {
            self.tibShockLabel.text = String(format: "%.2f", tibShock) + "G"
            
            if let tsThres = g_currentUser?.tsThres{
                if tsThres != 0 && tibShock > tsThres && g_isAudioOn && type == "new"{
                    playTsAudio()
                }
            }
        }
        
        if cadence != 0 {
            self.cadLabel.text = String(cadence)
        }
    }
    
    func playTsAudio(){
        let url = Bundle.main.url(forResource: "msg", withExtension: "wav")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension TrialViewController: SensorManagerToTrialDelegate{
    func unexpectedDisconnect() {
        
        // play disconnection alert
        playDisconnectAudio()
        
        // stop timer and data collection
        self.timer.invalidate()
        periController.stopSensorRead()
        DataCollector.shared.stopSensorRead()

        // present notification & ask whether to save record
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        
        let alert = UIAlertController(title: "Sensor Disconnected", message: "An unexpected disconnection event happens. Please reconnect the sensor.\n Would you like to save record?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            
            if let start = self.startingTime,
                let user = g_currentUser,
                let type = self.type{
                let userNum = user.num
                let recordNum = Int64(start.timeIntervalSince1970)
                let startTime = start
                
                DataSaver.shared.doFinalSave(userNum: userNum, recordNum: recordNum, time: startTime, duration: Int64(self.time), type: type)
            }
            
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Not Save", style: .default, handler: {action in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true)
    }
    
    func playDisconnectAudio(){
        
        let url = Bundle.main.url(forResource: "beep", withExtension: "wav")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
