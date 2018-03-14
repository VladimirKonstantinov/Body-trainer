//
//  vcInformationImageCollectionCell.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 11.03.17.
//  Copyright © 2017 Vladimir Konstantinov. All rights reserved.
//

import UIKit

class vcInformationImageCell: UITableViewCell {

    @IBOutlet weak var lName: UILabel!
    @IBOutlet weak var imgImage: UIImageView!

    var informationImage:InformationImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
