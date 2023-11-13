//
//  TeamHeaderView.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import UIKit

protocol LinkNavigationDelegate: AnyObject {
    func navigateTo(link: String?)
}
class TeamHeaderView: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var uiImage: UIImageView!
    @IBOutlet private var uiColorsView: [UIView]!
    @IBOutlet private weak var uiShortTitle: UILabel!
    @IBOutlet private weak var uiFallName: UILabel!
    @IBOutlet private weak var uiFoundationStack: UIStackView!
    @IBOutlet private weak var uiFoundation: UILabel!
    @IBOutlet private weak var uiAddressStack: UIStackView!
    @IBOutlet private weak var uiAddress: UILabel!
    @IBOutlet private weak var uiStadiumStack: UIStackView!
    @IBOutlet private weak var uiStadium: UILabel!
    @IBOutlet private weak var uiLinkButton: UIButton!
    
    private weak var delegate: LinkNavigationDelegate?
    private var link: String?
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    func configure(delegate: LinkNavigationDelegate, model: LeagueDetailsViewDataModel) {
        self.delegate = delegate
        self.link = model.link
        uiShortTitle.text = model.shortName
        uiFallName.text = model.name
        uiFoundation.text = model.foundation
        uiAddress.text = model.address
        uiStadium.text = model.stadium
        let defaultImage = #imageLiteral(resourceName: "logo")
        if let image = model.image, let url = URL(string: image) {
            uiImage.sd_setImage(with: url, placeholderImage: defaultImage)
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
    @IBAction func uiLinkPressed(_ sender: UIButton) {
        delegate?.navigateTo(link: self.link)
    }
}
