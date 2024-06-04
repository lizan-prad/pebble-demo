//
//  WelcomeCoordinator.swift
//  EtherWallet
//
//  Created by test on 02/05/2022.
//

import UIKit

class WelcomeCoordinator: Coordinator {
    func start() {
        let vc = WelcomeViewController.instantiate()
        vc.pin = pin
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    var pin: String?
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func getMainView() -> WelcomeViewController {
        let vc = WelcomeViewController.instantiate()
//        vc.viewModel = ImmunizationProfileViewModel()
//        vc.hidesBottomBarWhenPushed = true
        return vc
    }
}
