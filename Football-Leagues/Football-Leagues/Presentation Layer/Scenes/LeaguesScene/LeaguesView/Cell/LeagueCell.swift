//
//  LeagueCell.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import UIKit
import SDWebImage

class LeagueCell: UITableViewCell {

    @IBOutlet weak var uiLogo: UIImageView!
    @IBOutlet weak var uiTitle: UILabel!
    @IBOutlet weak var uiNumberOfTeams: UILabel!
    @IBOutlet weak var uiNumberOfGames: UILabel!
    @IBOutlet weak var uiNumberOfSeasons: UILabel!
    @IBOutlet weak var uiExtraDetailsStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        uiExtraDetailsStack.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(withModel model: LeaguesVieweDataModel){
        if let urlString = model.imageUrl,let url = URL(string: urlString){
            let placeholder = #imageLiteral(resourceName: "logo")
            uiLogo.sd_setImage(with: url, placeholderImage: placeholder)
        }
        
        uiTitle.text = model.title ?? "League"
    }
    
}
