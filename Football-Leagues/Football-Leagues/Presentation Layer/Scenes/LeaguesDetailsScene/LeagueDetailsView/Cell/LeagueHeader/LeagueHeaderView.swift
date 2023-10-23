//
//  LeagueHeaderView.swift
//  Football-Leagues
//
//  Created by Amin on 21/10/2023.
//

import UIKit

class LeagueHeaderView: UIView {

    @IBOutlet private weak var uiImage: UIImageView!
    @IBOutlet private weak var uiTitle: UILabel!
    @IBOutlet private weak var uiTypeStack: UIStackView!
    @IBOutlet private weak var uiType: UILabel!
    
    @IBOutlet weak var uiAreaStack: UIStackView!
    @IBOutlet private weak var uiArea: UILabel!
    
    @IBOutlet weak var uiClubsStack: UIStackView!
    @IBOutlet private weak var uiClubs: UILabel!
    @IBOutlet private var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    func configure(withModel model:LeaguesDetailsViewDataModel){
        uiTitle.text = model.header?.name
        uiArea.text = model.header?.area
        uiType.text = model.header?.type
        uiClubs.text = model.countOfTeams?.description
        if let imagePath = model.header?.imageUrl,let url = URL(string: imagePath){
            let image = #imageLiteral(resourceName: "logo")
            self.uiImage.sd_setImage(with: url,placeholderImage: image)
        }
        
        if let area = model.header?.area{
            animate {
                self.uiAreaStack.isHidden = false
                self.uiArea.text = area
            }completion: {}
        }
        
        if let type = model.header?.type{
            animate {
                self.uiTypeStack.isHidden = false
                self.uiType.text = type
            }completion: {}
        }
        
        if let teamse = model.countOfTeams{
            animate {
                self.uiClubsStack.isHidden = false
                self.uiClubs.text = teamse.description
            } completion: {}

        }
        
    }
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
