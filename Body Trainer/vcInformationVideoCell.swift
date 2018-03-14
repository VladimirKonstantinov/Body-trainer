//
//  vcInformationVideoCell.swift
//  Body Trainer
//
//  Created by Vladimir Konstantinov on 23.03.17.
//  Copyright © 2017 Vladimir Konstantinov. All rights reserved.
//

import UIKit

class vcInformationVideoCell: UITableViewCell {

    
    @IBOutlet weak var lName: UILabel!
    @IBOutlet weak var imgPreviewImage: UIImageView!
    @IBOutlet weak var lDuration: UILabel!
    
    var informationVideo:InformationVideo!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
