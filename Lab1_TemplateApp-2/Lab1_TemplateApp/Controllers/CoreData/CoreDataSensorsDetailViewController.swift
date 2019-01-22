//
//  CoreDataSensorsDetailViewController.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataSensorsDetailViewController: BaseSensorsDetailViewController {
    // MARK: - Properties
    let coreDataService: AnyCoreDataService = CoreDataService.shared
    var sensors: [NSManagedObject] = []
    var count: Int = 0;
    override var databaseService: AnyDatabaseService {
        return coreDataService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSensors()
    }
    
    func loadSensors() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sensor")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "name") as! String)
            }
            self.sensors = result as! [NSManagedObject]
            self.count = sensors.count
        } catch {
            print("Failed")
        }
    }
}
// MARK: - UITableViewDataSource
extension CoreDataSensorsDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sensor = sensors[indexPath.row]
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let name = sensor.value(forKey: "name") as! String
        let desc = sensor.value(forKey: "desc") as! String
        cell.textLabel?.text = "\(name): \(desc)"
        return cell
    }
}
