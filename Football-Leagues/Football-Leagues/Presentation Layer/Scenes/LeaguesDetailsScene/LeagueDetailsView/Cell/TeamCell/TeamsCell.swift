//
//  TeamsCell.swift
//  Football-Leagues
//
//  Created by Amin on 21/10/2023.
//

import UIKit

class TeamsCell: UITableViewCell {

    @IBOutlet private weak var uiImage: UIImageView!
    @IBOutlet private var uiColorsView: [UIView]!
    @IBOutlet private weak var uiShortTitle: UILabel!
    @IBOutlet private weak var uiTitleStack: UIStackView!
    @IBOutlet private weak var uiFallName: UILabel!
    @IBOutlet private weak var uiFoundationStack: UIStackView!
    @IBOutlet private weak var uiFoundation: UILabel!
    @IBOutlet private weak var uiAddressStack: UIStackView!
    @IBOutlet private weak var uiAddress: UILabel!
    @IBOutlet private weak var uiStadiumStack: UIStackView!
    @IBOutlet private weak var uiStadium: UILabel!
    
    @IBOutlet weak var uiLinkButton: UIButton!
    private var model:LeagueDetailsViewDataModel!
    private var viewModel:leagueDetailsVMProtocol!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        [uiTitleStack,uiAddressStack,uiStadiumStack,uiFoundationStack]
            .forEach{$0?.isHidden = true}
        uiLinkButton.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func linkPressed(_ sender: UIButton) {
        viewModel.input.onTappingLink.send(model.link)
    }
    
    func configure(withModel model:LeagueDetailsViewDataModel,viewModel:leagueDetailsVMProtocol){
        self.model = model
        self.viewModel = viewModel
        
        uiShortTitle.text = model.shortName
        uiFallName.text = model.name
        uiFoundation.text = model.foundation
        uiAddress.text = model.address
        uiStadium.text = model.stadium
        let defaultImage = #imageLiteral(resourceName: "logo")
        if let image = model.image ,let url = URL(string: image){
            uiImage.sd_setImage(with: url,placeholderImage: defaultImage)
        }
        if let _ = uiAddress{
            self.uiAddressStack.isHidden = false
        }
        if let _ = uiFoundation{
            self.uiFoundationStack.isHidden = false
        }
        if let _ = uiStadium{
            self.uiStadiumStack.isHidden = false
        }
        if let _ = uiFallName{
            self.uiTitleStack.isHidden = false
        }
        if let _ = model.link {
            self.uiLinkButton.isHidden = false
        }
        
        zip(self.uiColorsView,model.colors).forEach { view,colorName in
            view.backgroundColor = UIColor.getColor(name: colorName)
        }
        uiColorsView.forEach{$0.layer.borderWidth = 1}
        uiColorsView[0].layer.borderColor = UIColor.customColor(.greenColor).cgColor
        uiColorsView[1].layer.borderColor = UIColor.customColor(.greenColor).cgColor
    }
}

