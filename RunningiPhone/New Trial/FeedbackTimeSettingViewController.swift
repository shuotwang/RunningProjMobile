//
//  FeedbackTimeSettingViewController.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/30.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit
import Eureka

class FeedbackTimeSettingViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Feedback Time Trial"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBtnPressed))
        
        self.setTable()
    }
    
    @objc func saveBtnPressed() {
        
    }
    
    func setTable() {
        UIView.performWithoutAnimation {
            
            form +++ Section("Feedback Time Settings")
                
                <<< DoublePickerInlineRow<String, String>() {
                    $0.title = "Feedback Time 1"
                    $0.firstOptions = { return ["0 m", "1 m", "2 m", "3 m", "4 m", "5 m", "6 m", "7 m", "8 m", "9 m", "10 m", "11 m", "12 m", "13 m", "14 m", "15 m", "16 m", "17 m", "18 m", "19 m", "20 m", "21 m", "22 m", "23 m", "24 m", "25 m", "26 m", "27 m", "28 m", "29 m", "30 m", "31 m", "32 m", "33 m", "34 m", "35 m", "36 m", "37 m", "38 m", "39 m", "40 m", "41 m", "42 m", "43 m", "44 m", "45 m", "46 m", "47 m", "48 m", "49 m", "50 m", "51 m", "52 m", "53 m", "54 m", "55 m", "56 m", "57 m", "58 m", "59 m"]
                    }
                    $0.secondOptions = { _ in return ["0 s", "1 s", "2 s", "3 s", "4 s", "5 s", "6 s", "7 s", "8 s", "9 s", "10 s", "11 s", "12 s", "13 s", "14 s", "15 s", "16 s", "17 s", "18 s", "19 s", "20 s", "21 s", "22 s", "23 s", "24 s", "25 s", "26 s", "27 s", "28 s", "29 s", "30 s", "31 s", "32 s", "33 s", "34 s", "35 s", "36 s", "37 s", "38 s", "39 s", "40 s", "41 s", "42 s", "43 s", "44 s", "45 s", "46 s", "47 s", "48 s", "49 s", "50 s", "51 s", "52 s", "53 s", "54 s", "55 s", "56 s", "57 s", "58 s", "59 s"]
                    }
                }.cellUpdate{ cell, row in
                    cell.textLabel?.textColor = .white
                    cell.tintColor = .white
                }
                
                <<< DoublePickerInlineRow<String, String>() {
                    $0.title = "No Feedback Time"
                    $0.firstOptions = { return ["0 m", "1 m", "2 m", "3 m", "4 m", "5 m", "6 m", "7 m", "8 m", "9 m", "10 m", "11 m", "12 m", "13 m", "14 m", "15 m", "16 m", "17 m", "18 m", "19 m", "20 m", "21 m", "22 m", "23 m", "24 m", "25 m", "26 m", "27 m", "28 m", "29 m", "30 m", "31 m", "32 m", "33 m", "34 m", "35 m", "36 m", "37 m", "38 m", "39 m", "40 m", "41 m", "42 m", "43 m", "44 m", "45 m", "46 m", "47 m", "48 m", "49 m", "50 m", "51 m", "52 m", "53 m", "54 m", "55 m", "56 m", "57 m", "58 m", "59 m"]
                    }
                    $0.secondOptions = { _ in return ["0 s", "1 s", "2 s", "3 s", "4 s", "5 s", "6 s", "7 s", "8 s", "9 s", "10 s", "11 s", "12 s", "13 s", "14 s", "15 s", "16 s", "17 s", "18 s", "19 s", "20 s", "21 s", "22 s", "23 s", "24 s", "25 s", "26 s", "27 s", "28 s", "29 s", "30 s", "31 s", "32 s", "33 s", "34 s", "35 s", "36 s", "37 s", "38 s", "39 s", "40 s", "41 s", "42 s", "43 s", "44 s", "45 s", "46 s", "47 s", "48 s", "49 s", "50 s", "51 s", "52 s", "53 s", "54 s", "55 s", "56 s", "57 s", "58 s", "59 s"]
                    }
                }.cellUpdate{ cell, row in
                    cell.textLabel?.textColor = .white
                    cell.tintColor = .white
                }
                
                <<< DoublePickerInlineRow<String, String>() {
                    $0.title = "Feedback Time 2"
                    $0.firstOptions = { return ["0 m", "1 m", "2 m", "3 m", "4 m", "5 m", "6 m", "7 m", "8 m", "9 m", "10 m", "11 m", "12 m", "13 m", "14 m", "15 m", "16 m", "17 m", "18 m", "19 m", "20 m", "21 m", "22 m", "23 m", "24 m", "25 m", "26 m", "27 m", "28 m", "29 m", "30 m", "31 m", "32 m", "33 m", "34 m", "35 m", "36 m", "37 m", "38 m", "39 m", "40 m", "41 m", "42 m", "43 m", "44 m", "45 m", "46 m", "47 m", "48 m", "49 m", "50 m", "51 m", "52 m", "53 m", "54 m", "55 m", "56 m", "57 m", "58 m", "59 m"]
                    }
                    $0.secondOptions = { _ in return ["0 s", "1 s", "2 s", "3 s", "4 s", "5 s", "6 s", "7 s", "8 s", "9 s", "10 s", "11 s", "12 s", "13 s", "14 s", "15 s", "16 s", "17 s", "18 s", "19 s", "20 s", "21 s", "22 s", "23 s", "24 s", "25 s", "26 s", "27 s", "28 s", "29 s", "30 s", "31 s", "32 s", "33 s", "34 s", "35 s", "36 s", "37 s", "38 s", "39 s", "40 s", "41 s", "42 s", "43 s", "44 s", "45 s", "46 s", "47 s", "48 s", "49 s", "50 s", "51 s", "52 s", "53 s", "54 s", "55 s", "56 s", "57 s", "58 s", "59 s"]
                    }
                }.cellUpdate{ cell, row in
                    cell.textLabel?.textColor = .white
                    cell.tintColor = .white
            }
            
        }
    }
}
