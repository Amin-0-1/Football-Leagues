//
//  LeaguesDetailsView.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import UIKit
import Combine
class LeagueDetailsViewController: UIViewController {

    @IBOutlet weak var uiNotFound: UIView!
    @IBOutlet weak var uiTableView: UITableView!
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemGreen
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        return refreshControl
    }()

    var viewModel: LeagueDetailsViewModelProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: LeagueDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    private func configureView() {
        uiTableView.register(
            UINib(nibName: TeamsCell.nibName, bundle: nil),
            forCellReuseIdentifier: TeamsCell.reuseIdentifier
        )
        uiTableView.register(
            UINib(nibName: TeamsHeaderCell.nibName, bundle: nil),
            forHeaderFooterViewReuseIdentifier: TeamsHeaderCell.reuseIdentifier
        )
        self.uiTableView.addSubview(refreshControl)
    }
    private func bind() {
        viewModel.showError.sink { [weak self] message in
            guard let self = self else {return}
            self.showError(message: message) {
                self.uiNotFound.isHidden = false
            }
            
        }.store(in: &cancellables)
        viewModel.progress.sink { [weak self] isProgress in
            guard let self = self else {return}
            isProgress ? self.showProgress() : self.hideProgress()
        }.store(in: &cancellables)
        viewModel.teams.sink { [weak self] model in
            guard let self = self else {return}
            guard !model.models.isEmpty else {return}
            self.title = model.header?.name
            self.configureHeaderView(withData: model)
            self.uiNotFound.isHidden = true
            self.uiTableView.reloadData()

        }.store(in: &cancellables)

        viewModel.onScreenAppeared.send(false)
    }
    
    @objc func refreshControlValueChanged() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.onScreenAppeared.send(true)
            self.refreshControl.endRefreshing()
        }
    }
    
    private func configureHeaderView(withData data: LeaguesDetailsViewDataModel) {
        let header = LeagueHeaderView(frame: .init(x: 0, y: 0, width: uiTableView.frame.width, height: 200))
        header.configure(withModel: data)
        uiTableView.tableHeaderView = header
    }

}

extension LeagueDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.modelCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TeamsCell.reuseIdentifier
        ) as? TeamsCell else {fatalError("unable to Cell")}
        
        let model = viewModel.getModel(index: indexPath.row)
        cell.configure(withModel: model, viewModel: self.viewModel)
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard viewModel.modelCount > 0 else {return nil}
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TeamsHeaderCell.reuseIdentifier
        ) as? TeamsHeaderCell else {fatalError("Unable to dequeue cell")}
        headerView.backgroundConfiguration = .clear()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension LeagueDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        viewModel.onTappingCell.send(indexPath.row)
        return indexPath
    }
}
