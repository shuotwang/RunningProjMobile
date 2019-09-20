//
//  TrialViewController.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/19.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit

class TrialViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tibShockLabel: UILabel!
    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var finishBtn: UIButton!
    
    var time = 0
    var isPaused = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        
        startBtn.setTitle("Start", for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func startBtnPressed(_ sender: Any) {
        isPaused = !isPaused
        
        if isPaused{
            startBtn.setTitle("Continue", for: .normal)
        }else {
            startBtn.setTitle("Pause", for: .normal)
        }
    }
    
    @IBAction func finishBtnPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Save Records?", message: "Are you sure to save record?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            // 1. save
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
