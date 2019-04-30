//
//  ClubTableViewCell.swift
//  FootballStatsFilters-coreData4
//
//  Created by Gilbert Andrei Floarea on 14/04/2019.
//  Copyright © 2019 Gilbert Andrei Floarea. All rights reserved.
//

import UIKit

class ClubTableViewCell: UITableViewCell {

    @IBOutlet weak var cupsLabel: UILabel!
    @IBOutlet weak var clubPriceBracketLabel: UILabel!
    @IBOutlet weak var clubTrophiesWon: UILabel!
    @IBOutlet weak var clubNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
