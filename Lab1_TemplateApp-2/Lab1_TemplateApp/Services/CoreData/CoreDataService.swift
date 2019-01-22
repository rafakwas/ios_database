//
//  CoreDataService.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import CoreData
import UIKit
protocol AnyCoreDataService: AnyDatabaseService {
    // TODO: - Add extra methods if needed
}

class CoreDataService {
    // MARK: - Static Properties
    static let shared: CoreDataService = CoreDataService()
    // MARK: - Properties
    var startTime: Date?
    // MARK: - Private Properties
    fileprivate var observingHandlers: [Int: DatabaseServiceHandler] = [:]
    // MARK: - Init
    private init() {
        // TODO: Configure Service If You want
    }
    deinit {
        observingHandlers.removeAll()
    }
    // MARK: - Private Help/Cofigure/Init etc. Methods
    // TODO: - Work There...
}

extension CoreDataService: AnyCoreDataService {
    // MARK: - AnyDatabaseService -
    // MARK: - Generate Methods
    func generate(recordsNumber: Int) {
        notifyObservers(change: .logLine("CoreData"))
        notifyObservers(change: .logLine("generating \(recordsNumber) records"))
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sensor")
        var sensors : [Sensor] = []
        do {
            let result = try context.fetch(request)
            sensors = result as! [Sensor]
        } catch {
            print("Failed")
        }
        for index in 1...recordsNumber {
            let parentSensor = sensors[Int(arc4random_uniform(UInt32(sensors.count)))]
            let newReading = Reading(context: context)
            newReading.setValue(Date(), forKey: "timestamp")
            let value = Float(arc4random()) / 0xFFFFFFFF
            newReading.setValue(value, forKey: "value")
            parentSensor.addToReadings(newReading)
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    // MARK: - Experiments Methods
    func makeExperiment(recordsNumber: Int) {
        notifyObservers(change: .logLine("CoreData"))
        notifyObservers(change: .logLine("making experiment on \(recordsNumber) records"))
        deleteAllRecords()
        generate(recordsNumber: 100)
        startMeasureTime()
        let max = fetchMaxTimestamp()
        let maxMeasureTime = finishMeasureTime()
        notifyObservers(change: .logLine("max \(max). time \(maxMeasureTime)"))
        let min = fetchMinTimestamp();
        let minMeasureTime = finishMeasureTime();
        notifyObservers(change: .logLine("min \(min). time \(minMeasureTime)"))
        startMeasureTime()
        let avg = averageRecordValue()
        let avgMeasureTime = finishMeasureTime();
        notifyObservers(change: .logLine("avg \(avg). time \(avgMeasureTime)"))
        averageValuePerSensor()
    }
    
    func fetchMaxTimestamp() -> Date {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        fetchRequest.fetchLimit = 1
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let result = try context.fetch(fetchRequest) as! [Reading]
            let max = result.first
            return max?.value(forKey: "timestamp") as! Date
        } catch _ {
            
        }
        return Date();
    }
    
    func fetchMinTimestamp() -> Date {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        fetchRequest.fetchLimit = 1
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let result = try context.fetch(fetchRequest) as! [Reading]
            let max = result.first
            return max?.value(forKey: "timestamp") as! Date
        } catch _ {
            
        }
        return Date();
    }
    
    func averageRecordValue() -> Float {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        var sum : Float = 0;
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                sum += data.value(forKey: "value") as! Float
            }
            return sum / Float(result.count);
        } catch {
            print("Failed")
        }
        return 0;
    }
    func averageValuePerSensor() {
        startMeasureTime()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sensor")
        var sensors : [Sensor] = []
        do {
            let result = try context.fetch(request)
            sensors = result as! [Sensor]
        } catch {
            print("Failed")
        }
        var sum : Float = 0;
        var avg : Float = 0;
        for sensor in sensors {
            for reading in sensor.readings?.allObjects as! [Reading] {
                sum += reading.value
            }
            if (Float(sensor.readings?.count as! Int) > 0) {
                avg = sum / Float(sensor.readings?.count as! Int)
            } else {
                avg = 0;
            }
            print(avg)
            sum = 0;
        }
    }
    // MARK: - Delete Methods
    func deleteAllRecords() {
        notifyObservers(change: .logLine("CoreData"))
        notifyObservers(change: .logLine("deleting all the records"))
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request : NSFetchRequest<Reading> = Reading.fetchRequest()
        let objects = try! context.fetch(request)
        for obj in objects {
            context.delete(obj)
        }
        
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    // MARK: - Handler Methods
    func addHandler(_ completion: @escaping DatabaseServiceHandler) -> Int {
        var maxId = observingHandlers.keys.max() ?? 0
        maxId += 1
        observingHandlers[maxId] = completion
        return maxId
    }
    func removeHandler(_ handlerId: Int) {
        observingHandlers.removeValue(forKey: handlerId)
    }
    private func notifyObservers(change: DatabaseServiceChange) {
        observingHandlers.forEach { (handler) in
            handler.value(change)
        }
    }
}
