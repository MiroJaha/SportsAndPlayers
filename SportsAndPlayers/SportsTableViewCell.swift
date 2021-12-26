//
//  PlayersTableViewCell.swift
//  SportsAndPlayers
//
//  Created by admin on 24/12/2021.
//

import UIKit

class SportsTableViewCell: UITableViewCell {
    
    var sportsAndPlayersDelegate: SportsAndPlayersDelegate?
    
    var indexPath: NSIndexPath?

    @IBOutlet weak var sportImageView: UIImageView!
    @IBOutlet weak var sportNameLabel: UILabel!
    @IBOutlet weak var addImageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addImgaeButtonClicked(_ sender: UIButton) {
        sportsAndPlayersDelegate?.saveImage(indexPath: indexPath)
    }
}
