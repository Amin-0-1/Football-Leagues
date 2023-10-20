//
//  LeaguesViewController.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import UIKit
import Combine


class LeaguesViewController: UIViewController {

    var viewModel:LeaguesViewModel!
    
    private var refreshControl : UIRefreshControl!
    private var cancellable:Set<AnyCancellable> = []
    @IBOutlet private weak var uiTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
        viewModel.input.onScreenAppeared.send(false)
    }
    private func configureView(){
        title = "Football Leagues"
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemGreen
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        uiTableView.addSubview(refreshControl)
        uiTableView.register(UINib(nibName: LeagueCell.nibName, bundle: nil), forCellReuseIdentifier: LeagueCell.reuseIdentifier)
    }
    private func bind(){
        
        // MARK: - View Model Binding

        viewModel.output.progress.sink {[weak self] value in
            guard let self = self else {return}
            value ? self.showProgress() : self.hideProgress()
        }.store(in: &cancellable)
        
        viewModel.output.showError.sink { [weak self] message in
            guard let self = self else {return}
            self.showError(message: message)
        }.store(in: &cancellable)
        
        viewModel.output.leagues.sink {[weak self] model in
            guard let self = self else {return}
            self.uiTableView.reloadData()
        }.store(in: &cancellable)
    }
    @objc func refreshControlValueChanged(){
        self.viewModel.input.onScreenAppeared.send(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.refreshControl.endRefreshing()
        }
    }
}

extension LeaguesViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.publishableLeagues.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LeagueCell.reuseIdentifier) as? LeagueCell else {fatalError()}
        let model = viewModel.output.publishableLeagues.value[indexPath.row]
        cell.configure(withModel: model)
        return cell
    }
}
extension LeaguesViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.onTappedCell.send(indexPath.row)
    }
}
