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
    @IBOutlet weak var uiTypeLabel: UILabel!
    @IBOutlet weak var uiTypeStack: UIStackView!
    @IBOutlet weak var uiAreaLabel: UILabel!
    @IBOutlet weak var uiAreaStack: UIStackView!
    @IBOutlet weak var uiNumberOfSeasons: UILabel!
    @IBOutlet weak var uiSeasonStack: UIStackView!
    @IBOutlet weak var uiExtraDetailsStack: UIStackView!
    
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
    
    func configure(withModel model: LeaguesVieweDataModel){
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
