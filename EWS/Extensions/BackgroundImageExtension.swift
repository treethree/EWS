//
//  BackgroundImageExtension.swift
//  EWS
//
//  Created by SHILEI CUI on 4/9/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    /// This function sets an image as the background of the view controller
    ///
    /// - Parameters:
    ///   - imageName: name of image
    ///   - contentMode:
    ///          .scaleAspectFill
    ///          .scaleAspectFit
    ///          .scaleToFill
    func setBackgroundImage(_ imageName: String, contentMode: UIView.ContentMode) {
        DispatchQueue.main.async {
            let backgroundImage = UIImageView(frame: self.view.bounds)
            backgroundImage.image = UIImage(named: imageName)
            backgroundImage.contentMode = contentMode
            self.view.insertSubview(backgroundImage, at: 0)
        }
        
    }
    
}
