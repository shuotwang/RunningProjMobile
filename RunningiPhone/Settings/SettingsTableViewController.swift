//
//  SettingsTableViewController.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/19.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return 44
        case 2:
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
            return "Switch User"
        default:
            return "Nothing"
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            let userCell = tableView.dequeueReusableCell(withIdentifier: "userDisplayCell", for: indexPath) as! UserDisplayTableViewCell
            
            userCell.userName.text = "Someone"
            userCell.userInfo.text = "Something"
            
            cell = userCell
        case 1:
            if indexPath.row == 0{
                let tibShockCell = tableView.dequeueReusableCell(withIdentifier: "rightEditCell", for: indexPath) as! RightEditTableViewCell
                
                tibShockCell.titleLabel.text = "Tibial Shock Threshold"
                
                tibShockCell.rightTextField.text = "Something"

                
                cell = tibShockCell
            }
            
            else if indexPath.row == 1{
                let audioFeedbackCell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchTableViewCell
                
                audioFeedbackCell.titleLabel?.text = "Tibial Shock Audio Feedback"
                
                cell = audioFeedbackCell
            }
        case 2:
            let changeUserCell = UITableViewCell()
            
            changeUserCell.accessoryType = .disclosureIndicator
            changeUserCell.textLabel?.text = "Change User"
            
            cell = changeUserCell
        default:
            break
        }
        
        return cell
    }
    
    
    
//    userInfoDetailSegue
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            performSegue(withIdentifier: "userInfoSegue", sender: self)
        case 1:
            if indexPath.row == 0 {
                
            }
        case 2:
            performSegue(withIdentifier: "userInfoDetailSegue", sender: self)
        default:
            break
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "userInfoSegue":
            let newVC = segue.destination as! UserInfoTableViewController
        case "userInfoDetailSegue":
            let newVC = segue.destination as! UserListTableViewController
        default:
            break
        }
    }
    
    // MARK: - Audio Feedback Switch
    @IBAction func audioSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("is on")
        } else {
            print("is off")
        }
    }
    
    
}
