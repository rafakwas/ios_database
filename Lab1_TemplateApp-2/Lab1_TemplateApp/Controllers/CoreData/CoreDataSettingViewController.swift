//
//  CoreDataSettingViewController.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation

class CoreDataSettingViewController: BaseSettingViewController {
    // MARK: - Properties
    let coreDataService: AnyCoreDataService = CoreDataService.shared
    override var databaseService: AnyDatabaseService {
        return coreDataService
    }
}
