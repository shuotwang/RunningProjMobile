//
//  UserListTableViewController.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/19.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit

class UserListTableViewController: UITableViewController {
    
    var selectedIdxPath: IndexPath?
    
    var users: [User]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let curUser = g_currentUser{
            let idx = users?.firstIndex(of: curUser)
            if let index = idx{
                self.tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .middle)
            }
        }
        
        navigationItem.title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnPressed))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.users = CoreDataHelper.shared.readAllUsers()
        self.tableView.reloadData()
    }
    
    @objc func addBtnPressed() {
        var newVC = UIViewController()
        if #available(iOS 13.0, *) {
            let vc = storyboard?.instantiateViewController(identifier: "newUserVC") as! NewUserTableViewController
            vc.newUserDelegate = self
            newVC = vc
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "newUserVC") as! NewUserTableViewController
            vc.newUserDelegate = self
            newVC = vc
        }
        let newNav = UINavigationController.init(rootViewController: newVC)
        present(newNav, animated: true, completion: nil)
    }


    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let users = self.users{
            return users.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let users = self.users {
                let userNum = users[indexPath.row].num
                CoreDataHelper.shared.deleteUserWith(num: userNum)
                self.users?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                UserDefaults.standard.set(0, forKey: "curUser")
                g_currentUser = nil
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if let users = self.users{
            let currentUser = users[indexPath.row]
            cell.textLabel?.text = currentUser.name
            
            if currentUser == g_currentUser{
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let users = self.users{
            // update user
            g_currentUser = users[indexPath.row]
            UserDefaults.standard.set(Int(users[indexPath.row].num), forKey: "curUser")
            tableView.reloadData()
        }
    }
}

extension UserListTableViewController: NewUserDelegate{
    func saveBtnPressed() {
        self.users = CoreDataHelper.shared.readAllUsers()
        self.tableView.reloadData()
    }
}
