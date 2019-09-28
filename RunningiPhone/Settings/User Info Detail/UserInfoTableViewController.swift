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
    
    var user: User?
    
    let numberFormatter = NumberFormatter()
    let tsFormatter = NumberFormatter()
    let genders = ["Male", "Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUserInfoUI()
        
        self.navigationItem.title = "User Info"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBtnPressed))
        
        tableView.isUserInteractionEnabled = false
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        
        tsFormatter.numberStyle = .decimal
        tsFormatter.maximumFractionDigits = 2
    }
    
    @objc func editBtnPressed() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnPressed))
        tableView.isUserInteractionEnabled = true
    }
    
    @objc func doneBtnPressed() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBtnPressed))
        tableView.isUserInteractionEnabled = false
        
        // Save Changes:
        if let user = self.user{
            let formValues = self.form.values()
            let userNum = user.num
            if let subNum = formValues["subNum"],
                let tsThres = formValues["tsThres"],
                let name = formValues["Name"],
                let gender = genders.firstIndex(of: (formValues["Gender"] as! String)),
                let height = formValues["Height"],
                let weight = formValues["Weight"],
                let birthday = formValues["Birthday"]{
                    CoreDataHelper.shared.updateUserWith(num: userNum,
                                                         subNum: Int64(subNum as! Int),
                                                         name: name as! String,
                                                         gender: Int64(gender),
                                                         height: height as! Double,
                                                         weight: weight as! Double,
                                                         birthday: birthday as! Date)
                if let tsThres = tsThres{
                    CoreDataHelper.shared.updateUserWithNewThres(num: userNum, tsThres: tsThres as! Double)
                }
            }
        }
    }
    
    
    private func setUserInfoUI() {
        UIView.performWithoutAnimation {
            form +++ Section("Personal Info")
                
                <<< IntRow(){ row in
                    row.title = "Subject Number"
                    row.tag = "subNum"
                    row.value = Int(user?.subNum ?? -1)
                }.cellUpdate{ cell, row in
                    cell.titleLabel?.textColor = .white
                    cell.textField.textColor = .white
                }
                
                <<< TextRow(){ row in
                    row.title = "Name"
                    row.tag = "Name"
                    row.value = user?.name
                }.cellUpdate{ cell, row in
                    cell.titleLabel?.textColor = .white
                    cell.textField.textColor = .white
                }
                
                <<< DateRow(){
                    $0.title = "Birthday"
                    $0.tag = "Birthday"
                    $0.value = user?.birthday
                        
                }.cellUpdate{ cell, row in
                    cell.datePicker.setValue(false, forKeyPath: "highlightsToday")
                    cell.textLabel?.textColor = .white
                    cell.detailTextLabel?.textColor = .white
            }
            
            
            form +++ Section("Body Info")
                
                <<< SegmentedRow<String>(){
                    $0.options = genders
                    $0.title = "Gender"
                    $0.tag = "Gender"
                    $0.value = genders[Int(user?.gender ?? 0)]
                }.cellUpdate{ cell, row in
                    cell.titleLabel?.textColor = .white
                    cell.tintColor = .gray
                }
                
                
                <<< DecimalRow() {
                    $0.title = "Height (cm)"
                    $0.tag = "Height"
                    $0.formatter = numberFormatter
                    $0.value = user?.height
                    $0.placeholder = "in cm, 1 decimal place"
                    $0.placeholderColor = .gray
                }.cellUpdate{ cell, row in
                    cell.titleLabel?.textColor = .white
                    cell.textField.textColor = .white
                    cell.tintColor = .gray
                }
                
                
                <<< DecimalRow() {
                    $0.title = "Weight (kg)"
                    $0.tag = "Weight"
                    $0.formatter = numberFormatter
                    $0.value = user?.weight
                    $0.placeholder = "in kg, 1 decimal place"
                    $0.placeholderColor = .gray
            }.cellUpdate{ cell, row in
                cell.titleLabel?.textColor = .white
                cell.textField.textColor = .white
                cell.tintColor = .gray
            }
            
            form +++ Section("Training Info")
            <<< DecimalRow() {
                $0.title = "Tibial Shock Threshold (G)"
                $0.tag = "tsThres"
                $0.formatter = tsFormatter
                $0.value = user?.tsThres
                $0.placeholder = "2 decimal places"
                $0.placeholderColor = .gray
            }.cellUpdate{ cell, row in
                cell.titleLabel?.textColor = .white
                cell.textField.textColor = .white
                cell.tintColor = .gray
            }
        }
    }
}

