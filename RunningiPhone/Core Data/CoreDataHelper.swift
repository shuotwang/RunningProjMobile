//
//  CoreDataHelper.swift
//  RunningiPhone
//
//  Created by Vincent on 2019/9/21.
//  Copyright © 2019 Vincent. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {
    static let shared = CoreDataHelper()
    
    lazy var context: NSManagedObjectContext = {
        let context = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
        return context
    }()
        
    private func saveContext() {
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}


// MARK: - User
extension CoreDataHelper {
    func createUserWith(num: Int64,
                        subNum: Int64,
                        name: String,
                        gender: Int64,
                        height: Double,
                        weight: Double,
                        birthday: Date){
        let record = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
        
        record.num = num
        record.subNum = subNum
        record.name = name
        record.birthday = birthday
        
        record.gender = gender
        record.height = height
        record.weight = weight
        
        saveContext()
    }
    
    func readAllUsers() -> [User]{
        let fetchRequest: NSFetchRequest = User.fetchRequest()
        do {
            let records = try context.fetch(fetchRequest)
            return records
        } catch {
            fatalError();
        }
    }
    
    func updateUserWith(num: Int64,
                        subNum: Int64,
                        name: String,
                        gender: Int64,
                        height: Double,
                        weight: Double,
                        birthday: Date){
        let fetchRequest: NSFetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "num == %d", num)
        do {
            let records = try context.fetch(fetchRequest)
            for record in records {
                record.name = name
                record.subNum = subNum
                record.birthday = birthday
                
                record.gender = gender
                record.height = height
                record.weight = weight
            }
        } catch {
            fatalError()
        }
        saveContext()
    }
    
    
    func findUserWith(num: Int) -> User?{
        let fetchRequest: NSFetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "num == %d", num)
        
        do {
            let records = try context.fetch(fetchRequest)
            return records[0]
        } catch {
            fatalError()
        }
    }
    
    func deleteUserWith(num: Int64) {
        let fetchRequest: NSFetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "num == %d", num)
        do {
            let records = try context.fetch(fetchRequest)
            for record in records {
                context.delete(record)
            }
        } catch {
            fatalError()
        }
        saveContext()
    }
}


// MARK: - Records
extension CoreDataHelper {
    func createRecordWith(userNum: Int64,
                          recordNum: Int64,
                          time: Date,
                          duration: Int64,
                          type: String,
                          accTimeStamp: [Double],
                          accX: [Double],
                          accY: [Double],
                          accZ: [Double],
                          gyrTimeStamp: [Double],
                          gyrX: [Double],
                          gyrY: [Double],
                          gyrZ: [Double],
                          tibShock: [Double],
                          tibShockPos: [Double],
                          cadence: [Int]){
        let record = NSEntityDescription.insertNewObject(forEntityName: "Record", into: context) as! Record
        
        record.userNum = userNum
        record.recordNum = recordNum
        record.time = time
        record.duration = duration
        record.type = type
        
        record.accTimeStamp = accTimeStamp
        record.accX = accX
        record.accY = accY
        record.accZ = accZ
        
        record.gyrTimeStamp = gyrTimeStamp
        record.gyrX = gyrX
        record.gyrY = gyrY
        record.gyrZ = gyrZ
        
        record.tibShock = tibShock
        record.tibShockPos = tibShockPos
        record.cadence = cadence
        
        saveContext()
    }
    
    func findRecordsWith(userNum: Int64) -> [Record]? {
        let fetchRequest: NSFetchRequest = Record.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userNum == %d", userNum)
        
        do {
            let records = try context.fetch(fetchRequest)
            return records
        } catch {
            fatalError()
        }
    }
    
    func deleteRecordWith(recordNum: Int64) {
        let fetchRequest: NSFetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "recordNum == %d", recordNum)
        do {
            let records = try context.fetch(fetchRequest)
            for record in records {
                context.delete(record)
            }
        } catch {
            fatalError()
        }
        saveContext()
    }
    
   
}

