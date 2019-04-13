//
//  IconSizeExtension.swift
//  EWS
//
//  Created by SHILEI CUI on 4/13/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
extension GMSMarker {
    func setIconSize(scaledToSize newSize: CGSize) {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        icon = newImage
    }
}
