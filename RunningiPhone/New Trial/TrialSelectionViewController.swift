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
