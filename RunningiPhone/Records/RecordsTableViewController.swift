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
        if let user = g_currentUser{
            records = CoreDataHelper.shared.findRecordsWith(userNum: user.num)
        }
        self.selectedRecordIdx = nil
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 150
        case 1:
            return 200
        case 2:
            return 49
        case 3:
            return 49
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
        case 2:
            return "Feedback Time"
        case 3:
            return "Data Export"
        default:
            return "Nothing"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.selectedRecordIdx != nil {
            return 4
        }
        else{
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 2
        case 3:
            return 3
        default:
            return 0
        }
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
        case 2:
            cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            if let records = self.records,
                let selectedIdx = self.selectedRecordIdx{
                let record = records[selectedIdx]
                if indexPath.row == 0{
                    cell.textLabel?.textColor = .white
                    cell.isUserInteractionEnabled = false
                    cell.textLabel?.text = "No Feedback From"
                    cell.detailTextLabel?.text = String(format: "%.02d", record.fb1/60)+":"+String(format: "%.02d", record.fb1%60)
                }
                else if indexPath.row == 1 {
                    cell.textLabel?.textColor = .white
                    cell.isUserInteractionEnabled = false
                    cell.textLabel?.text = "Feedback Resume at"
                    cell.detailTextLabel?.text = String(format: "%.02d", (record.fb1+record.nofb)/60)+":"+String(format: "%.02d", (record.fb1+record.nofb)%60)
                }
            }

        case 3:
            if indexPath.row == 0 {
                cell.textLabel?.text = "Export IMU Record"
            }else if indexPath.row == 1{
                cell.textLabel?.text = "Export Tibial Shock Record"
            }else if indexPath.row == 2{
                cell.textLabel?.text = "Export Cadence Record"
            }
            
        default:
            break
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section{
        case 3:
            
            if indexPath.row == 0{
                if let records = self.records,
                   let index = self.selectedRecordIdx{
                   let currentRecord = records[index]
                   if let accTimeStamp = currentRecord.accTimeStamp,
                       let accXs = currentRecord.accX,
                       let accYs = currentRecord.accY,
                       let accZs = currentRecord.accZ{
                       DataExporter.createImuCsv(viewController: self,
                                                 fileName: String(currentRecord.recordNum),
                                                 userNum: currentRecord.userNum,
                                                 accTimeStamp: accTimeStamp,
                                                 accXs: accXs, accYs: accYs, accZs: accZs,
                                                 gyrTimeStamp: currentRecord.gyrTimeStamp,
                                                 gyrXs: currentRecord.gyrX, gyrYs: currentRecord.gyrY, gyrZs: currentRecord.gyrZ)
                   }
               }
            }
            
            else if indexPath.row == 1{
                if let records = self.records,
                    let index = self.selectedRecordIdx{
                    let currentRecord = records[index]
                    if let tsRecord = currentRecord.tibShock,
                        let tsPosRecord = currentRecord.tibShockPos{
                        DataExporter.createTsCsv(viewController: self,
                                                 fileName: String(currentRecord.recordNum),
                                                 userNum: currentRecord.userNum,
                                                 tsRecord: tsRecord,
                                                 tsPosRecord: tsPosRecord)
                    }
                }
            }
            
            else if indexPath.row == 2{
                if let records = self.records,
                    let index = self.selectedRecordIdx{
                    let currentRecord = records[index]
                    if let cadence = currentRecord.cadence{
                        DataExporter.createCadCsv(viewController: self,
                                                  fileName: String(currentRecord.recordNum),
                                                  userNum: currentRecord.userNum,
                                                  cadence: cadence)
                    }
                }
            }
            
           
        default:
            break
        }
    }
}

extension RecordsTableViewController: RecordsSummaryDelegate {
    func passRecordIdx(index: Int) {
        self.selectedRecordIdx = index
        self.tableView.reloadData()
    }
    
    func deleteCell(toBeDeletedNum: Int) {
        let alert = UIAlertController(title: "Delete Record", message: "Are you sure to delete record?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            CoreDataHelper.shared.deleteRecordWith(recordNum: Int64(toBeDeletedNum))
            self.records = CoreDataHelper.shared.findRecordsWith(userNum: g_currentUser!.num)
            
            
            // update index
            self.selectedRecordIdx = nil
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            print("No")
        }))
        
        self.present(alert, animated: true)
    }
}
