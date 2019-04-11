//
//  Earthquake.swift
//  EWS
//
//  Created by SHILEI CUI on 4/11/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation

struct Earthquake: Codable {
    let features: [Feature]
}

struct Feature: Codable {
    let geometry: Geometry
}

struct Geometry: Codable {
    let coordinates: [Double]
}
