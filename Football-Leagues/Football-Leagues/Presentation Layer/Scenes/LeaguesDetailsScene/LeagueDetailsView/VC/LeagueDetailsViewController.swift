//
//  LeaguesDetailsView.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import UIKit
import Combine
class LeagueDetailsViewController: UIViewController {

    @IBOutlet weak var uiTableView: UITableView!
    private lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemGreen
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        return refreshControl
    }()
    
    
    var viewModel:leagueDetailsVMProtocol!
    
    private var cancellables:Set<AnyCancellable> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
    }
    private func configureView(){
        uiTableView.register(UINib(nibName: TeamsCell.nibName, bundle: nil), forCellReuseIdentifier: TeamsCell.reuseIdentifier)
        self.uiTableView.addSubview(refreshControl)
    }
    private func bind(){
        viewModel.output.publishableError.sink { [weak self] message in
            guard let self = self else {return}
            self.showError(message: message)
        }.store(in: &cancellables)
        viewModel.output.publishableProgress.sink { [weak self] isProgress in
            guard let self = self else {return}
            isProgress ? self.showProgress() : self.hideProgress()
        }.store(in: &cancellables)
        viewModel.output.publishableTeams.sink { [weak self] model in
            guard let self = self else {return}
            guard !model.models.isEmpty else {return}
            self.configureHeaderView(withData: model)
            self.uiTableView.reloadData()

        }.store(in: &cancellables)

        viewModel.input.onScreenAppeared.send(false)
    }
    
    @objc func refreshControlValueChanged(){
        self.viewModel.input.onScreenAppeared.send(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.refreshControl.endRefreshing()
        }
    }
    
    private func configureHeaderView(withData data:LeaguesDetailsViewDataModel){
        let header = LeagueHeaderView(frame: .init(x: 0, y: 0, width: uiTableView.frame.width, height: 200))
        header.configure(withModel: data)
        uiTableView.tableHeaderView = header
    }

}

extension LeagueDetailsViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.publishableTeams.value.countOfTeams ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TeamsCell.reuseIdentifier) as? TeamsCell else {fatalError()}
        let model = viewModel.output.publishableTeams.value.models[indexPath.row]
        cell.configure(withModel:model,viewModel:self.viewModel)
        return cell
    }
}
