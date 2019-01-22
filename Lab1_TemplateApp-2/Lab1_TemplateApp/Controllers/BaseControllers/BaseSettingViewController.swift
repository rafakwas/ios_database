//
//  BaseSettingViewController.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BaseSettingViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var recordsCountTextField: UITextField!
    @IBOutlet weak var logsTextView: UITextView!
    @IBOutlet weak var logsView: UIView!
    // MARK: - Properties
    var handlerId: Int = 0
    var databaseService: AnyDatabaseService! {
        assertionFailure("Overrite property")
        return nil
    }
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        configureService()
        createSensors()
    }
    deinit {
        unsubscribe()
    }
    // MARK: - Configure Methods
    func configureService() {
        subscribe()
    }
    
    func createSensors() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Sensor", in: context)
        for index in 1...20 {
            let newSensor = NSManagedObject(entity: entity!, insertInto: context)
            newSensor.setValue("S\(index)", forKey: "name")
            newSensor.setValue("Sensor number \(index)", forKey: "desc")
//            print("created")
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
    // MARK: - Private Subscribe/Unsubscribe
    /**
     For each experiment, make sure to log:
     1.  the execution time,
     2.  SQL queries used to obtain result (for all SELECT queries),
     3.  results (for all SELECT queries).
     */
    func subscribe() {
        handlerId = databaseService.addHandler { [weak self] (change) in
            guard let `self` = self else { return }
            switch change {
            case .generatingRecordsFinished(let recordsCount): break
            //TODO: Measure Time for Generating
            case .experimentFinished(let recordsCount): break
            //TODO: Measure Time for Experiment
            case .logLine(let logString):
                DispatchQueue.main.async {
                    self.log(line: logString)
                }
            }
        }
    }
    func unsubscribe() {
        databaseService.removeHandler(handlerId)
    }
    // MARK: - Actions
    @IBAction func generateCustomRecordsCountAction(_ sender: UIButton) {
        guard let text = recordsCountTextField.text,
            let recordsCount = Int(text) else { return }
        databaseService.generate(recordsNumber: recordsCount)
    }
    @IBAction func generateThousandRecordsAction(_ sender: UIButton) {
        databaseService.generate(recordsNumber: 1000)
    }
    @IBAction func generateMillionRecordsAction(_ sender: UIButton) {
        databaseService.generate(recordsNumber: 1000000)
    }
    @IBAction func makeExperimentThousandAction(_ sender: UIButton) {
        databaseService.makeExperiment(recordsNumber: 1000)
    }
    @IBAction func makeExperimentMillionAction(_ sender: UIButton) {
        databaseService.makeExperiment(recordsNumber: 1000000)
    }
    @IBAction func deleteAllAction(_ sender: UIButton) {
        databaseService.deleteAllRecords()
    }
    @IBAction func showLogsAction(_ sender: UIButton) {
        showLogs(true, animated: true)
    }
    @IBAction func hideLogsAction(_ sender: UIButton) {
        showLogs(false, animated: true)
    }
    @IBAction func clearLogsAction(_ sender: UIButton) {
        logsTextView.text = ""
    }
    // MARK: - Private Help Methods
    func log(line: String) {
        logsTextView.text = logsTextView.text + "\n\(line)"
    }
    // MARK: - Animation Methods
    func showLogs(_ isShow: Bool, animated: Bool) {
        if isShow { logsView.isHidden = false }
        UIView.animate(withDuration: animated ? 0.2 : 0.0, animations: {
            self.logsView.alpha = isShow ? 1.0 : 0.0
        }) { (_) in
            if !isShow { self.logsView.isHidden = true }
        }
    }
}
