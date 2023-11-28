//
//  PlayerCell.swift
//  Football-Leagues
//
//  Created by Amin on 22/11/2023.
//

import UIKit
import SDWebImage
class PlayerCell: UITableViewCell {

    @IBOutlet private weak var uiClupImage: UIImageView!
    @IBOutlet private weak var uiPlayerName: UILabel!
    @IBOutlet private weak var uiPosition: UILabel!
    @IBOutlet private weak var uiNationality: UILabel!
    
    private let placHolder = #imageLiteral(resourceName: "logo")
    func configure(squad: StaffViewDataModel) {
        uiPlayerName.text = squad.name
        uiPosition.text = squad.position
        uiNationality.text = squad.nationality
        if let urlString = squad.clubImageURL, let url = URL(string: urlString) {
            uiClupImage.sd_setImage(with: url, placeholderImage: placHolder)
        }
    }
}
