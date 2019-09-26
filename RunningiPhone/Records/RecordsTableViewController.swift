//
//  RecordsTableViewController.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/19.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit

class RecordsTableViewController: UITableViewController {
    
    var records: [Record]?
    
    var selectedRecordIdx: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Records"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        if let user = g_currentUser{
            records = CoreDataHelper.shared.findRecordsWith(userNum: user.num)
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 150
        case 1:
            return 200
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Summaries"
        case 1:
            return "Details"
        default:
            return "Nothing"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            let summaryCell = tableView.dequeueReusableCell(withIdentifier: "recordsSummaryCell", for: indexPath) as! RecordsSummaryTableViewCell
            if let records = self.records{
                summaryCell.records = records
                summaryCell.summaryCollectionView.reloadData()
            }
            summaryCell.recordsSummaryDelegate = self
            cell = summaryCell
        case 1:
            let detailCell = tableView.dequeueReusableCell(withIdentifier: "recordsDetailCell", for: indexPath) as! RecordsDetailTableViewCell
            
            if let index = self.selectedRecordIdx,
                let records = self.records{
                detailCell.record = records[index]
                detailCell.detailCollectionView.reloadData()
            }
            
            cell = detailCell
        default:
            break
        }

        return cell
    }
}

extension RecordsTableViewController: RecordsSummaryDelegate {
    func passRecordIdx(index: Int) {
        self.selectedRecordIdx = index
        self.tableView.reloadData()
    }
}
