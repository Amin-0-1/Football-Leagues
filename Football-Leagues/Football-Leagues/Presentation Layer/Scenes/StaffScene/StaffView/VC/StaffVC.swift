//
//  StaffVC.swift
//  Football-Leagues
//
//  Created by Amin on 22/11/2023.
//

import UIKit

class StaffVC: UIViewController {

    @IBOutlet private weak var uiTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let playerNib = UINib(nibName: PlayerCell.nibName, bundle: nil)
        uiTableView.register(playerNib, forCellReuseIdentifier: PlayerCell.reuseIdentifier)
    }
}

extension StaffVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PlayerCell.reuseIdentifier,
            for: indexPath
        ) as? PlayerCell else {
            print("unable to dequeue cell with identifier \(PlayerCell.reuseIdentifier)")
            return .init()
        }
        return cell
    }
}
