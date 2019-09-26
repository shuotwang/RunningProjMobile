//
//  DataExporter.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/25.
//  Copyright © 2019 Vincent. All rights reserved.
//

import Foundation

class DataExporter {
    
    static func createImuCsv(viewController: UIViewController, fileName: String, userNum: Int64, accTimeStamp: [Double], accXs: [Double], accYs: [Double], accZs: [Double], gyrTimeStamp: [Double]?, gyrXs:[Double]?, gyrYs: [Double]?, gyrZs: [Double]?) {
        
        let fileName = fileName + "_" + String(userNum) + "_Imu.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "accTimeStamp,accX,accY,accZ,gyrTimeStamp,gyrX,gyrY,gyrZ\n"
        
        if let gyrTimeStamp = gyrTimeStamp,
        let gyrXs = gyrXs,
        let gyrYs = gyrYs,
        let gyrZs = gyrZs{
            if gyrXs.count > 0 && gyrYs.count > 0 && gyrZs.count > 0{
                for i in 0..<min(accTimeStamp.count, gyrTimeStamp.count){
                    let newLine = "\(accTimeStamp[i]),\(accXs[i]),\(accYs[i]),\(accZs[i]),\(gyrTimeStamp[i]),\(gyrXs[i]),\(gyrYs[i]),\(gyrZs[i])\n"
                    csvText.append(contentsOf: newLine)
                }
            }else {
                for i in 0..<accTimeStamp.count {
                    let newLine = "\(accTimeStamp[i]),\(accXs[i]),\(accYs[i]),\(accZs[i]),0,0,0,0\n"
                    csvText.append(contentsOf: newLine)
                }
            }
        }

        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create Imu Csv file")
            print("\(error)")
        }
        
        let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
        viewController.present(vc, animated: true, completion: nil)
    }
    
    static func createTsCsv(viewController: UIViewController, fileName: String, userNum: Int64, tsRecord: [Double], tsPosRecord: [Double]) {
        
        let fileName = fileName + "_" + String(userNum) + "_ts.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "tsPosTimeStamp,tsValue\n"
        
        for i in 0..<min(tsRecord.count, tsPosRecord.count) {
            let newLine = "\(tsPosRecord[i]),\(tsRecord[i])\n"
            csvText.append(contentsOf: newLine)
        }
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create Para Csv file")
            print("\(error)")
        }
        
        let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
        viewController.present(vc, animated: true, completion: nil)
    }
    
    static func createCadCsv(viewController: UIViewController, fileName: String, userNum: Int64, cadence: [Int]) {
        
        let fileName = fileName + "_" + String(userNum) + "_cad.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "cadence\n"
        
        for i in 0..<cadence.count {
            let newLine = "\(cadence[i]))\n"
            csvText.append(contentsOf: newLine)
        }
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create Para Csv file")
            print("\(error)")
        }
        
        let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
        viewController.present(vc, animated: true, completion: nil)
    }
}
