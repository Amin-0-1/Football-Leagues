//
//  LeaguesDetailsView.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import UIKit

class LeagueDetailsViewController: UIViewController {

    var viewModel:leagueDetailsVMProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.onScreenAppeared.send(false)
        bind()
    }
    private func bind(){
        
    }

}
