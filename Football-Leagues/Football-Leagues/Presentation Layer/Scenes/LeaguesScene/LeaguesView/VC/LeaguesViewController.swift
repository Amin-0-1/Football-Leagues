//
//  LeaguesViewController.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import UIKit
import Combine

class LeaguesViewController: UIViewController {

    @IBOutlet private weak var uiTableView: UITableView!
    @IBOutlet private weak var uiNotFound: UIView!
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemGreen
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        return refreshControl
    }()
    
    var viewModel: LeaguesViewModelProtocol
    private var cancellable: Set<AnyCancellable> = []
    
    init(viewModel: LeaguesViewModelProtocol) {
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
        viewModel.onScreenAppeared.send(false)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    private func configureView() {
        title = "Football Leagues"
        navigationController?.setNavigationBarHidden(true, animated: false)
  
        uiTableView.addSubview(refreshControl)
        uiTableView.register(
            UINib(
                nibName: LeagueCell.nibName,
                bundle: nil
            ),
            forCellReuseIdentifier: LeagueCell.reuseIdentifier
        )
    }
    private func bind() {
        
        // MARK: - View Model Binding

        viewModel.progress.sink {[weak self] value in
            guard let self = self else {return}
            value ? self.showProgress() : self.hideProgress()
        }.store(in: &cancellable)
        
        viewModel.showError.sink { [weak self] message in
            guard let self = self else {return}
            self.showError(message: message) {
                self.uiNotFound.isHidden = false
            }
        }.store(in: &cancellable)
        
        viewModel.leagues.sink {[weak self] _ in
            guard let self = self else {return}
            self.uiNotFound.isHidden = true
            self.uiTableView.reloadData()
        }.store(in: &cancellable)
    }
    @objc func refreshControlValueChanged() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.onScreenAppeared.send(true)
            self.refreshControl.endRefreshing()
        }
    }
}

extension LeaguesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.leagueCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
        .dequeueReusableCell(withIdentifier: LeagueCell.reuseIdentifier) as? LeagueCell
        else {fatalError("unable to dequeue cell")}
        let model = viewModel.getMode(forIndex: indexPath.row)
        cell.configure(withModel: model)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = .init(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 10) {
            cell.transform = .identity
        }
    }
}
extension LeaguesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onTappedCell.send(indexPath.row)
    }
}
