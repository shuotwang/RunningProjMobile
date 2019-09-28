//
//  TrialSelectionViewController.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/20.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit

//toConnectSegue

class TrialSelectionViewController: UIViewController {
    
    @IBOutlet weak var baselineTestBtn: UIButton!
    @IBOutlet weak var newTrialBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Running Trial"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.isUserInteractionEnabled = false
        self.view.alpha = 0.4
        
        // check if user is selected
        let curUser = UserDefaults.standard.integer(forKey: "curUser")
        if curUser == 0{
            let alert = UIAlertController(title: "No User Selected", message: "Please select user at Settings → Switch User", preferredStyle: .alert)
                   
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            self.view.isUserInteractionEnabled = true
            self.view.alpha = 1
        }
        
        // check if baseline exists
        let tsThres = g_currentUser?.tsThres
        if tsThres == 0{
            let alert = UIAlertController(title: "No Baseline Record", message: "Please do baseline test first, then switch to new training trial", preferredStyle: .alert)
                       
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            }))
            self.present(alert, animated: true, completion: nil)
            
            self.newTrialBtn.isEnabled = false
            self.newTrialBtn.alpha = 0.4
        }else {
            self.newTrialBtn.isEnabled = true
            self.newTrialBtn.alpha = 1
        }
    }
    
    @IBAction func baselineTestBtnPressed(_ sender: Any) {
        let type = "baseline"
        performSegue(withIdentifier: "toConnectSegue", sender: type)
    }
    
    @IBAction func newTrialBtnPressed(_ sender: Any) {
        let type = "new"
        performSegue(withIdentifier: "toConnectSegue", sender: type)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toConnectSegue":
            let nv = segue.destination as! NewTrialTableViewController
            nv.trialType = sender as? String
        default:
            break
        }
    }
}
