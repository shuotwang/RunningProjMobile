//
//  UserInfoTableViewController.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/19.
//  Copyright © 2019 Vincent. All rights reserved.
//

import Foundation
import Eureka

class UserInfoTableViewController: FormViewController{
    
    let numberFormatter = NumberFormatter()
    let genders = ["Male", "Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUserInfoUI()
        
        self.navigationItem.title = "User Info"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBtnPressed))
        
        tableView.isUserInteractionEnabled = false
    }
    
    @objc func editBtnPressed() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnPressed))
        tableView.isUserInteractionEnabled = true
    }
    
    @objc func doneBtnPressed() {
        // TODO: save changes
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBtnPressed))
        tableView.isUserInteractionEnabled = false
    }
    
    
    private func setUserInfoUI() {
        UIView.performWithoutAnimation {
            form +++ Section("Personal Info")
                
                <<< TextRow(){ row in
                    row.title = "Subject Number"
                    row.tag = "subNum"
                    //                    row.value = user?.name
                    
                }
                <<< TextRow(){ row in
                    row.title = "Name"
                    row.tag = "Name"
                    //                    row.value = user?.name
                    
                }
                
                <<< DateRow(){
                    $0.title = "Birthday"
                    $0.tag = "Birthday"
                    //                    $0.value = user?.birthday
                        
                    }.cellUpdate{ cell, row in
                        cell.datePicker.setValue(false, forKeyPath: "highlightsToday")
            }
            
            
            form +++ Section("Body Info")
                
                <<< SegmentedRow<String>(){
                    $0.options = genders
                    $0.title = "Gender"
                    $0.tag = "Gender"
                    $0.value = genders[0]
                }
                
                
                <<< DecimalRow() {
                    $0.title = "Height (cm)"
                    $0.tag = "Height"
                    $0.formatter = numberFormatter
                    //                    $0.value = user?.height
                    $0.placeholder = "in cm, 1 decimal place"
                    $0.placeholderColor = .gray
                }
                
                <<< DecimalRow() {
                    $0.title = "Weight (kg)"
                    $0.tag = "Weight"
                    $0.formatter = numberFormatter
                    //                    $0.value = user?.weight
                    $0.placeholder = "in kg, 1 decimal place"
                    $0.placeholderColor = .gray
            }
        }
    }
}

