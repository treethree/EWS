//
//  WeatherTableViewCell.swift
//  EWS
//
//  Created by SHILEI CUI on 4/9/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var timezoneLbl: UILabel!
    @IBOutlet weak var summaryLbl: UILabel!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
//    var temperature : String?
//    var timezone : String?
//    var summary : String?
//    var date : String?
//    var time : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        tempLbl.text = temperature
//        timezoneLbl.text = timezone
//        summaryLbl.text = summary
//        dateLbl.text = date
//        timeLbl.text = time
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
