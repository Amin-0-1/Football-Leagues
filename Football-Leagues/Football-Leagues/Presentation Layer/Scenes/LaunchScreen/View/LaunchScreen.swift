//
//  LaunchScreen.swift
//  Football-Leagues
//
//  Created by Amin on 23/10/2023.
//

import UIKit
import Lottie
class LaunchScreen: UIViewController {
    @IBOutlet weak var uiLottie: LottieAnimationView!
    var coordinator:LaunchScreenCoordinatorProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        uiLottie.loopMode = .loop
        uiLottie.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 6){
            self.coordinator.onFinishLoading()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        uiLottie.stop()
    }

}
