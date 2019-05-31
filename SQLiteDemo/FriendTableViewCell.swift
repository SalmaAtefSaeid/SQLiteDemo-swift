//
//  FriendTableViewCell.swift
//  SQLiteDemo
//
//  Created by Salma Atef Saeid on 5/30/19.
//  Copyright © 2019 Salma. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendPhoneLabel: UILabel!
    @IBOutlet weak var friendEmailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
