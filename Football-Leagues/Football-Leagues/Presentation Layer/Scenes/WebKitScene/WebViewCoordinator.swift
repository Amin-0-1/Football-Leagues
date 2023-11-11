//
//  WebViewCoordinator.swift
//  Football-Leagues
//
//  Created by Amin on 21/10/2023.
//

import UIKit

protocol WebViewControllerProtocol:AnyCoordinator{
    func dismiss()
}

struct WebViewCoordinator:WebViewControllerProtocol{
    var navigationController: UINavigationController?
    var data:URL
    
    init(navigationController: UINavigationController, data: URL) {
        self.navigationController = navigationController
        self.data = data
    }
    func start() {
        guard let navigationController = navigationController else {return}
        let vc = WebViewController()
        vc.coordinator = self
        vc.url = self.data
        navigationController.present(vc, animated: true)
    }
    
    func dismiss() {
        guard let navigationController = navigationController else {return}
        navigationController.dismiss(animated: true)
    }
}
