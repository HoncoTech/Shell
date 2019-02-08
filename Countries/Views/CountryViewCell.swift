//
//  CountryViewCell.swift
//  Countries
//
//  Created by Vineet Kumar on 2/6/19.
//  Copyright © 2019 Scorpion. All rights reserved.
//

import UIKit

class CountryViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var iconView : UIImageView!
    
    //MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
