//
//  NewUserTableViewController.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/21.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit
import Eureka

protocol NewUserDelegate {
    func saveBtnPressed()
}

class NewUserTableViewController: FormViewController {

    let numberFormatter = NumberFormatter()
    let genders = ["Male", "Female"]
    
    var newUserDelegate: NewUserDelegate?
    
    override func viewDidLoad() {
        
        print(CoreDataHelper.shared.readAllUsers())
        
        super.viewDidLoad()
        self.setUserInfoUI()
        
        self.navigationItem.title = "New User"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBtnPressed))
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
    }
    
    @objc func cancelBtnPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveBtnPressed() {
        let thisNum = Int64(Date().timeIntervalSince1970)
        
        let formvalues = self.form.values()
        if let name = formvalues["Name"],
            let subNum = formvalues["subNum"],
            let gender = genders.firstIndex(of: (formvalues["Gender"] as! String)),
            let height = formvalues["Height"],
            let weight = formvalues["Weight"],
            let birthday = formvalues["Birthday"]{
            
            if let name = name,
                let subNum = subNum,
                let height = height,
                let weight = weight,
                let birthday = birthday{
                CoreDataHelper.shared.createUserWith(num: thisNum,
                                                     subNum: Int64(subNum as! Int),
                                                     name: name as! String,
                                                     gender: Int64(gender),
                                                     height: height as! Double,
                                                     weight: weight as! Double,
                                                     birthday: birthday as! Date)
            }
            
        }
        
        self.newUserDelegate?.saveBtnPressed()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func setUserInfoUI() {
        UIView.performWithoutAnimation {
            form +++ Section("Personal Info")
                
                <<< IntRow(){ row in
                    row.title = "Subject Number"
                    row.tag = "subNum"
                }.cellUpdate{ cell, row in
                    cell.titleLabel?.textColor = .white
                    cell.textField.textColor = .white
                }
                
                <<< TextRow(){ row in
                    row.title = "Name"
                    row.tag = "Name"
                }.cellUpdate{ cell, row in
                    cell.titleLabel?.textColor = .white
                    cell.textField.textColor = .white
                }
                
                <<< DateRow(){
                    $0.title = "Birthday"
                    $0.tag = "Birthday"
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
                    $0.value = genders[0]
                }.cellUpdate{ cell, row in
                    cell.titleLabel?.textColor = .white
                    cell.tintColor = .gray
                }
                
                
                <<< DecimalRow() {
                    $0.title = "Height (cm)"
                    $0.tag = "Height"
                    $0.formatter = numberFormatter
                    //                    $0.value = user?.height
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
                    //                    $0.value = user?.weight
                    $0.placeholder = "in kg, 1 decimal place"
                    $0.placeholderColor = .gray
            }.cellUpdate{ cell, row in
                cell.titleLabel?.textColor = .white
                cell.textField.textColor = .white
                cell.tintColor = .gray
            }
        }
    }
}
