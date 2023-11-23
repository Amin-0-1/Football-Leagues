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
    @IBOutlet private weak var uiLinkButton: UIButton!
    
    private var model: LeagueDetailsViewDataModel?
    private var viewModel: LeagueDetailsViewModelProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        [
            uiTitleStack,
            uiAddressStack,
            uiStadiumStack,
            uiFoundationStack
        ].forEach { $0?.isHidden = true }
        uiLinkButton.isHidden = true
    }
    
    @IBAction func linkPressed(_ sender: UIButton) {
        viewModel?.onTappingLink.send(model?.link)
    }
    
    func configure(
        withModel model: LeagueDetailsViewDataModel,
        viewModel: LeagueDetailsViewModelProtocol
    ) {
        self.model = model
        self.viewModel = viewModel
        
        uiShortTitle.text = model.shortName
        uiFallName.text = model.name
        uiFoundation.text = model.foundation
        uiAddress.text = model.address
        uiStadium.text = model.stadium
        let defaultImage = #imageLiteral(resourceName: "logo")
        if let image = model.image, let url = URL(string: image) {
            let bitmapSize = CGSize(width: 500, height: 500)

            uiImage.sd_setImage(
                with: url,
                placeholderImage: defaultImage,
                options: [],
                context: [.imageThumbnailPixelSize: bitmapSize]
            )
        }
        if uiAddress != nil {
            self.uiAddressStack.isHidden = false
        }
        if uiFoundation != nil {
            self.uiFoundationStack.isHidden = false
        }
        if uiStadium != nil {
            self.uiStadiumStack.isHidden = false
        }
        if uiFallName != nil {
            self.uiTitleStack.isHidden = false
        }
        if model.link != nil {
            self.uiLinkButton.isHidden = false
        }
        
        zip(self.uiColorsView, model.colors).forEach { view, colorName in
            view.backgroundColor = UIColor.getColor(name: colorName)
        }
        uiColorsView.forEach { $0.layer.borderWidth = 1 }
        uiColorsView[0].layer.borderColor = UIColor.customColor(.greenColor).cgColor
        uiColorsView[1].layer.borderColor = UIColor.customColor(.greenColor).cgColor
    }
}
