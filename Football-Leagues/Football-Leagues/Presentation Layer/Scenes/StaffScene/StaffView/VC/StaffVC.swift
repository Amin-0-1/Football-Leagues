//
//  StaffVC.swift
//  Football-Leagues
//
//  Created by Amin on 22/11/2023.
//

import UIKit
import Combine

class StaffVC: UIViewController {

    @IBOutlet private weak var uiNotFound: UIImageView!
    @IBOutlet private weak var uiTableView: UITableView!
    private var viewModel: StaffViewModelProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    init(viewModel: StaffViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
        viewModel.onScreenAppeared.send()
    }
    private func setupView() {
        let playerNib = UINib(nibName: PlayerCell.nibName, bundle: nil)
        uiTableView.register(playerNib, forCellReuseIdentifier: PlayerCell.reuseIdentifier)
    }
    private func bind() {
        viewModel.error.sink { [weak self] error in
            guard let self = self else {return}
            self.showError(message: error) {
                self.uiNotFound.isHidden = false
            }
        }.store(in: &cancellables)
        viewModel.progress.sink { [weak self] show in
            guard let self = self else {return}
            show ? self.showProgress() : self.hideProgress()
        }.store(in: &cancellables)
        viewModel.onFinishFetching.sink { [weak self] _ in
            guard let self = self else {return}
            self.uiNotFound.isHidden = true
            self.uiTableView.reloadData()
        }.store(in: &cancellables)
        viewModel.title.sink { [weak self] title in
            guard let self = self else {return}
            self.title = title
        }.store(in: &cancellables)
    }
}

extension StaffVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.staffCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PlayerCell.reuseIdentifier,
            for: indexPath
        ) as? PlayerCell else {
            print("unable to dequeue cell with identifier \(PlayerCell.reuseIdentifier)")
            return .init()
        }
        if let squad = viewModel.getModel(forIndex: indexPath.row) {
            cell.configure(squad: squad)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = .init(translationX: -view.frame.width, y: 0)
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 1) {
            cell.transform = .identity
        }
    }
}
