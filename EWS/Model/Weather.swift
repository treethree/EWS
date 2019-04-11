//
//  Weather.swift
//  EWS
//
//  Created by SHILEI CUI on 4/9/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let latitude, longitude: Double
    let timezone: String
    let daily: Daily
}

struct Daily: Codable {
    let data: [DailyDatum]
    let summary: String
}

struct DailyDatum: Codable {
    let time: Int
    let summary: String
    let temperatureMin: Double
    let temperatureMax: Double
}
