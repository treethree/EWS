//
//  ImageButtonExtension.swift
//  EWS
//
//  Created by SHILEI CUI on 4/12/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
}
