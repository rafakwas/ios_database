//
//  RealmSensorsDetailViewController.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation
import UIKit

class RealmSensorsDetailViewController: BaseSensorsDetailViewController {
    // MARK: - Properties
    let realmService: AnyRealmService = RealmService.shared
    override var databaseService: AnyDatabaseService {
        return realmService
    }
}
// MARK: - UITableViewDataSource
extension RealmSensorsDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: - Implement Method
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: - Implement Method
        return UITableViewCell()
    }
}
