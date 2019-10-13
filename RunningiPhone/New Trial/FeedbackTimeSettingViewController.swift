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

        UIView.performWithoutAnimation {
            
            form +++ Section("Feedback Time Settings")
                <<< PickerRow<Int>() {row in
                    row.title = "First Feedback Time"
                    row.tag = "fbTime1"
                }.cellUpdate{cell, row in
                    cell.textLabel?.textColor = .white
                    cell.detailTextLabel?.textColor = .white
//                    cell.datePicker.datePickerMode.
            }
        }
    }
}
