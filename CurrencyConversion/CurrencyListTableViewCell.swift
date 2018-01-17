//
//  CurrencyListTableViewCell.swift
//  CurrencyConversion
//
//  Created by Naga Sai Jyothi  on 2017-12-20.
//  Copyright © 2017 Naga Sai Jyothi . All rights reserved.
//

import UIKit

class CurrencyListTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       self.cellLabel.text = "Hello"
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
