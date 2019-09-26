//
//  SettingsTableViewController.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/19.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var tibShockThres: Double = 8.0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        if let tsThres = g_tsThres{
            self.tibShockThres = tsThres
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let tsThres = g_tsThres{
            self.tibShockThres = tsThres
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return 44
        case 2:
            return 44
        case 3:
            return 44
        default:
            return 44
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "User Info"
        case 1:
            return "System Settings"
        case 2:
            return "Sensor Settings"
        case 3:
            return "Switch User"
        default:
            return "Nothing"
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Audio notification appears when tibial shock is higher than threshold."
        default:
            return ""
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            let userCell = tableView.dequeueReusableCell(withIdentifier: "userDisplayCell", for: indexPath) as! UserDisplayTableViewCell
            
            if let currentUser = g_currentUser{
                userCell.userName.text = currentUser.name
                
                // TODO: userInfo writes num of trials

            }else {
                userCell.userName.text = "Not Selected"
                userCell.userInfo.text = "Please select a user"
            }
            
            cell = userCell
        case 1:
            if indexPath.row == 0{
                let tibShockCell = tableView.dequeueReusableCell(withIdentifier: "rightEditCell", for: indexPath) as! RightEditTableViewCell
                
                tibShockCell.titleLabel.text = "Tibial Shock Threshold"
                tibShockCell.rightTextField.text = String(format: "%.2f", tibShockThres) + "G"

                cell = tibShockCell
            }
            
            else if indexPath.row == 1{
                let audioFeedbackCell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchTableViewCell
                
                audioFeedbackCell.titleLabel?.text = "Tibial Shock Audio Feedback"
                
                cell = audioFeedbackCell
            }
        case 2:
            let accgyrCell = tableView.dequeueReusableCell(withIdentifier: "accgyrCell", for: indexPath) as! SwitchTableViewCell
            accgyrCell.titleLabel.text = "Enable Gyroscope"
            cell = accgyrCell
        case 3:
            let changeUserCell = UITableViewCell()
            
            changeUserCell.accessoryType = .disclosureIndicator
            changeUserCell.textLabel?.text = "Change User"
            
            cell = changeUserCell
        default:
            break
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if g_currentUser != nil{
                performSegue(withIdentifier: "userInfoSegue", sender: self)
            }else {
                
                tableView.deselectRow(at: indexPath, animated: true)
                
                let alert = UIAlertController(title: "User Not Selected", message: "Please select a user in 'Change User'.", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                }))
                
                self.present(alert, animated: true)
            }
            
        case 1:
            if indexPath.row == 0 {
                
            }
        case 2:
            break
        case 3:
            performSegue(withIdentifier: "userListSegue", sender: self)
        default:
            break
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "userInfoSegue":
            let newVC = segue.destination as! UserInfoTableViewController
        case "userListSegue":
            let newVC = segue.destination as! UserListTableViewController
        default:
            break
        }
    }
    
    // MARK: = Tibshock Text field
    @IBAction func tibShockInput(_ sender: UITextField) {
        if let tibShock = sender.text{
            self.tibShockThres = Double(tibShock) as! Double
            tableView.reloadData()
        }
    }
    
    // MARK: - Audio Feedback Switch
    @IBAction func audioSwitch(_ sender: UISwitch) {
        if sender.isOn {
            g_isAudioOn = true
        } else {
            g_isAudioOn = false
        }
    }
    
    @IBAction func gyrSwitch(_ sender: UISwitch) {
        if sender.isOn {
            g_gyrIsOn = true
        } else {
            g_gyrIsOn = false
        }
    }
    
    
}
