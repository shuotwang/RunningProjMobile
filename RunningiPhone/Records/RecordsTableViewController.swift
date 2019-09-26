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
            return "Data Export"
        default:
            return "Nothing"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.selectedRecordIdx != nil {
            return 3
        }
        else{
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
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
            if indexPath.row == 0 {
                cell.textLabel?.text = "Export IMU record"
            }else if indexPath.row == 1{
                cell.textLabel?.text = "Export Tibial Shock record"
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
        case 2:
            
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
}
