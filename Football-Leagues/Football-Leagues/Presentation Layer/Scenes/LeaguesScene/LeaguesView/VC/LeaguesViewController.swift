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
    var onScreenAppeared: PublishSubject<Void>{get}
}
struct LeaguesVMInput:LeaguesVMInputProtocol{
    var onScreenAppeared: PublishSubject<Void>
    
    init() {
        self.onScreenAppeared = PublishSubject<Void>()
    }
}

class LeaguesViewController: UIViewController {

    var viewModel:LeaguesVMProtocol!
    var coordinator:Coordinating!
    private var bag:DisposeBag!
    @IBOutlet private weak var uiTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bind()
        viewModel.input.onScreenAppeared.onNext(())
    }
    private func configureView(){
        title = "Football Leagues"
        uiTableView.register(UINib(nibName: LeagueCell.nibName, bundle: nil), forCellReuseIdentifier: LeagueCell.reuseIdentifier)
        bag = DisposeBag()
    }
    private func bind(){
        
        viewModel.outPut.progress.asObservable().bind { [weak self] value in
            guard let self = self else {return}
            value ? self.showProgress() : self.hideProgress()
        }.disposed(by: bag)
        
        viewModel.outPut.showError.asObservable().subscribe { [weak self] message in
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
