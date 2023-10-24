//
//  LeagueCell.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import UIKit
import SDWebImage

class LeagueCell: UITableViewCell {

    @IBOutlet private weak var uiLogo: UIImageView!
    @IBOutlet private weak var uiTitle: UILabel!
    @IBOutlet private weak var uiTypeLabel: UILabel!
    @IBOutlet private weak var uiTypeStack: UIStackView!
    @IBOutlet private weak var uiAreaLabel: UILabel!
    @IBOutlet private weak var uiAreaStack: UIStackView!
    @IBOutlet private weak var uiNumberOfSeasons: UILabel!
    @IBOutlet private weak var uiSeasonStack: UIStackView!
    @IBOutlet private weak var uiExtraDetailsStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        [
         uiExtraDetailsStack,
         uiTypeStack,
         uiAreaStack,
         uiSeasonStack
        ].forEach{$0?.isHidden = true}
        
        [
        uiTypeLabel,
        uiAreaLabel,
        uiNumberOfSeasons
        ].forEach{$0?.text = 0.description}
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(withModel model: LeagueViewDataModel){
        if let urlString = model.imageUrl,let url = URL(string: urlString){
            let placeholder = #imageLiteral(resourceName: "logo")
            uiLogo.sd_setImage(with: url, placeholderImage: placeholder)
        }
        
        uiTitle.text = model.name ?? "League"
        
        if let type = model.type{
            animate{
                self.uiExtraDetailsStack.isHidden = false
            }completion: {
                self.uiTypeStack.isHidden = false
            }
            uiTypeLabel.text = type
        }
        
        if let area = model.area{
            animate{
                self.uiExtraDetailsStack.isHidden = false
            }completion: {
                self.uiAreaStack.isHidden = false
            }
            uiAreaLabel.text = area
        }
        
        if let seasons = model.numberOfSeasons{
            animate{
                self.uiExtraDetailsStack.isHidden = false
            }completion: {
                self.uiSeasonStack.isHidden = false
            }
            uiNumberOfSeasons.text = seasons.description
        }
    }
}
