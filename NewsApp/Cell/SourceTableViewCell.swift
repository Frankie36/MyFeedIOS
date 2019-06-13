//
//  SourceTableViewCell.swift
//  NewsApp
//
//  Created by Francis Ngunjiri on 13/06/2019.
//  Copyright © 2019 Francis Ngunjiri. All rights reserved.
//

import UIKit

class SourceTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
