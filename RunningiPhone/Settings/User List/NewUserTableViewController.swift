//
//  NewUserTableViewController.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/21.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit
import Eureka

class NewUserTableViewController: FormViewController {

    let numberFormatter = NumberFormatter()
    let genders = ["Male", "Female"]
    
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
            let gender = genders.firstIndex(of: (formvalues["Gender"] as! String)),
            let height = formvalues["Height"],
            let weight = formvalues["Weight"],
            let birthday = formvalues["Birthday"]{
            
            if let name = name,
                let height = height,
                let weight = weight,
                let birthday = birthday{
                CoreDataHelper.shared.createUserWith(num: thisNum,
                                                      name: name as! String,
                                                      gender: Int64(gender),
                                                      height: height as! Double,
                                                      weight: weight as! Double,
                                                      birthday: birthday as! Date)
            }
            
        }
        
        self.dismiss(animated: true, completion: nil)
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
