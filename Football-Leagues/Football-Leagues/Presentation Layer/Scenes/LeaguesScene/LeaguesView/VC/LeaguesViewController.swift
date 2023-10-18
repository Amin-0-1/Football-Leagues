//
//  LeaguesViewController.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import UIKit
import RxSwift
import RxCocoa


protocol LeaguesVMInputProtocol{
    var onScreenAppeared: PublishSubject<Bool>{get}
}
struct LeaguesVMInput:LeaguesVMInputProtocol{
    var onScreenAppeared: PublishSubject<Bool>
    
    init() {
        self.onScreenAppeared = PublishSubject<Bool>()
    }
}

class LeaguesViewController: UIViewController {

    var viewModel:LeaguesVMProtocol!
    var coordinator:Coordinating!
    
    private var refreshControl : UIRefreshControl!
    private var bag:DisposeBag!
    @IBOutlet private weak var uiTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
        viewModel.input.onScreenAppeared.onNext(false)
    }
    private func configureView(){
        title = "Football Leagues"
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemGreen
        uiTableView.addSubview(refreshControl)
        uiTableView.register(UINib(nibName: LeagueCell.nibName, bundle: nil), forCellReuseIdentifier: LeagueCell.reuseIdentifier)
        bag = DisposeBag()
    }
    private func bind(){
        
        // MARK: - View Binding
        refreshControl.rx.controlEvent(.valueChanged).bind{ [weak self] _ in
            guard let self = self else {return}
            viewModel.input.onScreenAppeared.onNext(true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.refreshControl.endRefreshing()
            }
            
        }.disposed(by: bag)
        
        
        // MARK: - View Model Binding
        viewModel.outPut.progress.asObservable().bind { [weak self] value in
            guard let self = self else {return}
            value ? self.showProgress() : self.hideProgress()
        }.disposed(by: bag)
        
        
        viewModel.outPut.showError.drive { [weak self] message in
            guard let self = self else {return}
            self.showError(message: message)
        }.disposed(by: bag)
        
        viewModel.outPut.onFinishFetchingLeagues.asObservable().bind(to: uiTableView.rx.items){ tableView,row,element in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LeagueCell.reuseIdentifier) as? LeagueCell else {fatalError()}
            cell.configure(withModel: element)
            return cell
        }.disposed(by: bag)
        
    }
}
