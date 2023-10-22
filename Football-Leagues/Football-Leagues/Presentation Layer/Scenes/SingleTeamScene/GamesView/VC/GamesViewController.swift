//
//  TeamsVC.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import UIKit
import Combine
class GamesViewController: UIViewController {

    @IBOutlet private weak var uiTableView: UITableView!
    
    var viewModl: gamesViewModelProtocol!
    private var cancellables:Set<AnyCancellable> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        viewModl.onScreenAppeared.send(false)
    }
    private func configureView(){
        let gameCellNib = UINib(nibName: GameCell.nibName, bundle: nil)
        let gameHeaderCellNib = UINib(nibName: GamesHeaderCell.nibName, bundle: nil)
        
        uiTableView.register(gameCellNib,forCellReuseIdentifier: GameCell.reuseIdentifier)
        uiTableView.register(gameHeaderCellNib, forHeaderFooterViewReuseIdentifier: GamesHeaderCell.reuseIdentifier)
        
        bind()
    }
    private func bind(){
        viewModl.showError.sink { [weak self] error in
            guard let self = self else {return}
            self.showError(message: error)
        }.store(in: &cancellables)
        viewModl.progress.sink { [weak self] value in
            guard let self = self else {return}
            value ? self.showProgress() : self.hideProgress()
        }.store(in: &cancellables)
        viewModl.leagueDetails.sink {[weak self] model in
            guard let self = self else {return}
            let header = TeamHeaderView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 250))
            header.configure(model: model)
            self.uiTableView.tableHeaderView = header
        }.store(in: &cancellables)
        
        viewModl.gamesDetails.sink { games in
            self.uiTableView.reloadData()
        }.store(in: &cancellables)
    }
}

extension GamesViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModl.gamesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GameCell.reuseIdentifier) as? GameCell else {fatalError()}
        cell.configure(model: viewModl.getModel(index: indexPath.row))
        cell.layoutIfNeeded()
        return cell
    }
}
extension GamesViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: GamesHeaderCell.reuseIdentifier) as? GamesHeaderCell else {fatalError()}
        let background = UIView(frame: view.bounds)
        background.backgroundColor = .clear
        headerView.backgroundView = background
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
