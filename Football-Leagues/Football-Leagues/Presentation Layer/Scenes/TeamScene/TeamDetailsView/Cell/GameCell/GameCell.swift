//
//  GameCell.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import UIKit

class GameCell: UITableViewCell {

    @IBOutlet var uiImagesLayer: [UIVisualEffectView]!
    @IBOutlet weak var uiHomeName: UILabel!
    @IBOutlet weak var uiHomeImage: UIImageView!
    @IBOutlet weak var uiAwayName: UILabel!
    @IBOutlet weak var uiAwayImage: UIImageView!
    
    @IBOutlet weak var uiStatus: UILabel!
    @IBOutlet weak var uiDate: UILabel!
    
    @IBOutlet weak var uiResultStack: UIStackView!
    @IBOutlet weak var uiAwayTeamScor: UILabel!
    @IBOutlet weak var uiHomeTeamScore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        uiImagesLayer.forEach { $0.layer.cornerRadius = $0.layer.frame.height / 2 }
        uiAwayTeamScor.layer.cornerRadius = 8
        uiHomeTeamScore.layer.cornerRadius = 8
    }
    
    func configure(model: TeamDetailsViewDataModel) {
        let defaultImage = #imageLiteral(resourceName: "logo")
        if let homeImage = model.homeTeam?.crest, let homeImageUrl = URL(string: homeImage) {
            self.uiHomeImage.sd_setImage(with: homeImageUrl, placeholderImage: defaultImage)
        }
        if let awayImage = model.awayTeam?.crest, let awayImageUrl = URL(string: awayImage) {
            self.uiAwayImage.sd_setImage(with: awayImageUrl, placeholderImage: defaultImage)
        }
        uiHomeName.text = model.homeTeam?.tla
        uiAwayName.text = model.awayTeam?.tla
        uiStatus.text = model.date
        uiHomeTeamScore.text = model.score?.home?.description
        uiAwayTeamScor.text = model.score?.away?.description
        uiStatus.text = model.status?.rawValue
        uiDate.text = model.date
        
        switch model.status {
            case .finished:
                uiResultStack.isHidden = false
            case .timed, .scheduled:
                uiResultStack.isHidden = true
            case .none:
                break
        }
        
        guard let winner = model.winner else {return}
        switch winner {
            case .home:
                uiHomeTeamScore.backgroundColor = .systemGreen
                uiAwayTeamScor.backgroundColor = .systemPink
            case .away:
                uiHomeTeamScore.backgroundColor = .systemPink
                uiAwayTeamScor.backgroundColor = .systemGreen
            case .draw:
                uiHomeTeamScore.backgroundColor = UIColor.customColor(.mainAuxilary2)
                uiAwayTeamScor.backgroundColor = UIColor.customColor(.mainAuxilary2)
        }
    }
}
