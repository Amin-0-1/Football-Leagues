//
//  LeaguesViewController.swift
//  Football-Leagues
//
//  Created by Amin on 16/10/2023.
//

import UIKit

class LeaguesViewController: UIViewController {
    
    var viewModel:LeaguesVMProtocol!
    var coordinator:Coordinating!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.onScreenAppeared.onNext(())
    }

}
