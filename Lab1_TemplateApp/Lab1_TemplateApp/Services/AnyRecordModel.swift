//
//  AnyRecordModel.swift
//  Lab1_TemplateApp
//
//  Created by Konstantyn on 12/5/18.
//  Copyright © 2018 Konstantyn Bykhkalo. All rights reserved.
//

import Foundation

// MARK: - AnyRecordModel
protocol AnyRecordModel {
    /// Properties
    var timestampRecord: Double { get }
    var valueRecord: Float { get }
    var sensorModel: AnySensorModel { get }
}
