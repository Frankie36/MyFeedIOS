//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Francis Ngunjiri on 12/06/2019.
//  Copyright © 2019 Francis Ngunjiri. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgStory: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblSource: UILabel!
    @IBOutlet weak var lblTimeStamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
