//
//  TeamDetailsViewController.swift
//  Football-Leagues
//
//  Created by Amin on 22/10/2023.
//

import UIKit
import Combine

class TeamDetailsViewController: UIViewController {

    @IBOutlet weak var uiNotFound: UIView!
    @IBOutlet private weak var uiTableView: UITableView!
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemGreen
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        return refreshControl
    }()
    
    var viewModl: TeamViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: TeamViewModelProtocol) {
        self.viewModl = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        viewModl.onScreenAppeared.send(false)
    }
    private func configureView() {
        uiTableView.addSubview(refreshControl)
        let gameCellNib = UINib(nibName: GameCell.nibName, bundle: nil)
        let gameHeaderCellNib = UINib(nibName: GamesHeaderCell.nibName, bundle: nil)
        
        uiTableView.register(gameCellNib, forCellReuseIdentifier: GameCell.reuseIdentifier)
        uiTableView.register(gameHeaderCellNib, forHeaderFooterViewReuseIdentifier: GamesHeaderCell.reuseIdentifier)
        uiTableView.estimatedRowHeight = 100
        uiTableView.rowHeight = UITableView.automaticDimension
        bind()
    }
    private func bind() {
        viewModl.showError.sink { [weak self] error in
            guard let self = self else {return}
            self.showError(message: error) {
                self.uiNotFound.isHidden = true
            }
        }.store(in: &cancellables)
        viewModl.progress.sink { [weak self] value in
            guard let self = self else {return}
            value ? self.showProgress() : self.hideProgress()
        }.store(in: &cancellables)
        viewModl.leagueDetails.sink {[weak self] model in
            guard let self = self else {return}
            title = model.name
            let header = TeamHeaderView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 250))
            header.configure(delegate: self, model: model)
            self.uiTableView.tableHeaderView = header
        }.store(in: &cancellables)
        
        viewModl.gamesDetails.sink { [weak self] _ in
            guard let self = self else {return}
            self.uiNotFound.isHidden = true
            self.uiTableView.reloadData()
        }.store(in: &cancellables)
    }
    @objc func refreshControlValueChanged() {

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModl.onScreenAppeared.send(true)
            self.refreshControl.endRefreshing()
        }
    }
}

extension TeamDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModl.gamesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
        .dequeueReusableCell(withIdentifier: GameCell.reuseIdentifier)
        as? GameCell else {fatalError("unable to dequeue")}
        
        cell.configure(model: viewModl.getModel(index: indexPath.row))
        cell.layoutIfNeeded()
        return cell
    }
}
extension TeamDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard viewModl.gamesCount != 0 else {return nil}
        guard let headerView = tableView
        .dequeueReusableHeaderFooterView(withIdentifier: GamesHeaderCell.reuseIdentifier)
        as? GamesHeaderCell else {fatalError("unable to dequeue")}
        
        headerView.backgroundConfiguration = .clear()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension TeamDetailsViewController: LinkNavigationDelegate {
    func navigateTo(link: String?) {
        viewModl.onTapLink.send(link)
    }
    func onStaffTapped() {
        viewModl.onStaffTapped.send()
    }
}
