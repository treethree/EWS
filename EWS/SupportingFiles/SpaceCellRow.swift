//
//  SpaceCellRow.swift
//  EWS
//
//  Created by SHILEI CUI on 4/10/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation
import Eureka

final class SpaceCellRow: Row<SpaceTableViewCell>, RowType {
    
    /**
     Initializes the row
     - parameter tag: tag for the row
     - returns: Void
     */
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<SpaceTableViewCell>(nibName: "SpaceTableViewCell")
    }
}

