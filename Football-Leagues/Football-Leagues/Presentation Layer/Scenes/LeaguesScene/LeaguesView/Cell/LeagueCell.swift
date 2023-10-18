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
    @IBOutlet weak var uiTeamsStack: UIStackView!
    @IBOutlet weak var uiNumberOfGames: UILabel!
    @IBOutlet weak var uiGamesStack: UIStackView!
    @IBOutlet weak var uiNumberOfSeasons: UILabel!
    @IBOutlet weak var uiSeasonStack: UIStackView!
    @IBOutlet weak var uiExtraDetailsStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        uiExtraDetailsStack.isHidden = true
        uiTeamsStack.isHidden = true
        uiGamesStack.isHidden = true
        uiSeasonStack.isHidden = true
        uiNumberOfTeams.text = 0.description
        uiNumberOfGames.text = 0.description
        uiNumberOfSeasons.text = 0.description
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
        
        if let teams = model.numberOfTeams{
            animate {
                self.uiExtraDetailsStack.isHidden = false
            } completion: {
                self.uiTeamsStack.isHidden = false
            }
            uiNumberOfTeams.text = teams.description
        }
        if let seasons = model.numberOfSeasons{
            animate {
                self.uiExtraDetailsStack.isHidden = false
            } completion: {
                self.uiSeasonStack.isHidden = false
            }
            uiNumberOfSeasons.text = seasons.description
        }
        if let matches = model.numberOfMatches{
            animate {
                self.uiExtraDetailsStack.isHidden = false
            } completion: {
                self.uiGamesStack.isHidden = false
            }
            uiNumberOfGames.text = matches.description
        }
    }
}

extension UIView{
    func animate(closure: @escaping()->Void,completion: @escaping()->Void){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            closure()
        }completion: { _ in
            completion()
        }
    }
}
