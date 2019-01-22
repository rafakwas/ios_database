//
//  CoreDataReadingsDetailViewController.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataReadingsDetailViewController: BaseReadingsDetailViewController {
    var readings: [NSManagedObject] = []
    // MARK: - Properties
    let coreDataService: AnyCoreDataService = CoreDataService.shared
    override var databaseService: AnyDatabaseService {
        return coreDataService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadReadings()
    }
    
    func loadReadings() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Reading")
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "value") as! Float)
            }
            self.readings = result as! [NSManagedObject]
        } catch {
            print("Failed")
        }
    }
}


// MARK: - UITableViewDataSource
extension CoreDataReadingsDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.readings.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reading = readings[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let value = reading.value(forKey: "value") as! Float
        let timestamp = reading.value(forKey: "timestamp") as! Date
        cell.textLabel?.text = "\(value): \(timestamp)"
        return cell
    }
}
