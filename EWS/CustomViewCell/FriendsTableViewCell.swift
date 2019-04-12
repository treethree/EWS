//
//  FriendsTableViewCell.swift
//  EWS
//
//  Created by SHILEI CUI on 4/11/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var fnameLbl: UILabel!
    @IBOutlet weak var lnameLbl: UILabel!
    @IBOutlet weak var deleteBtnOutlet: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
