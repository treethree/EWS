//
//  SplashView.swift
//  EWS
//
//  Created by SHILEI CUI on 4/14/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import Foundation

import VGContent

class SplashView: VGXibView {
    

    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Public Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
    override func setup(withItem item: Any!) {
        if let object = item as? String {
            self.imageView.image = UIImage(named: object)
        }
    }
    
}
