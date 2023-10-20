//
//  LeaguesViewController.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import UIKit
import Combine


protocol LeaguesVMInputProtocol{
    var onScreenAppeared: PassthroughSubject<Bool,Never> {get}
    var models:[LeaguesVieweDataModel] {get}
    var modelCount: Int {get}
}
struct LeaguesVMInput:LeaguesVMInputProtocol{
    var onScreenAppeared: PassthroughSubject<Bool,Never>
    var models: [LeaguesVieweDataModel]
    var modelCount: Int
    init() {
        self.onScreenAppeared = PassthroughSubject<Bool,Never>()
        models = []
        modelCount = 0
    }
    func getModel(atIndex index:Int)-> LeaguesVieweDataModel{
        return models[index]
    }
}

class LeaguesViewController: UIViewController {

    var viewModel:LeaguesVMProtocol!
    var coordinator:LeaguesCoordinatorProtocol!
    
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
        viewModel.outPut.progress.sink {[weak self] value in
            guard let self = self else {return}
            value ? self.showProgress() : self.hideProgress()
        }.store(in: &cancellable)
        
        viewModel.outPut.showError.sink { [weak self] message in
            guard let self = self else {return}
            self.showError(message: message)
        }.store(in: &cancellable)
        
        viewModel.outPut.onFinishFetchingLeagues.sink {[weak self] model in
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
        return viewModel.input.modelCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LeagueCell.reuseIdentifier) as? LeagueCell else {fatalError()}
        cell.configure(withModel: viewModel.input.getModel(atIndex: indexPath.row))
        return cell
    }
}
