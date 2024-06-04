//
//  ViewController.swift
//  EtherWallet
//
//  Created by test on 11/04/2022.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

//    @IBOutlet weak var ethLogo: UIImageView!
    
    var time = 0.0
    let context = LAContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let rotationTransform = CATransform3DRotate(ethLogo.layer.transform, CGFloat.pi, 1, 0, 0)
        
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { timer in
            self.time += 0.6
            //            UIView.animate(withDuration: 0.6) {
            //                self.ethLogo.layer.transform = rotationTransform
            //            }
            if self.time > 2 {
                timer.invalidate()
                if let _ = UserDefaults.standard.string(forKey: "AUTH") {
                    
                    if let _ = UserDefaults.standard.string(forKey: "FACE") {
                        let reason = "Log in with Face ID"
                        self.context.evaluatePolicy(
                            // .deviceOwnerAuthentication allows
                            // biometric or passcode authentication
                            .deviceOwnerAuthentication,
                            localizedReason: reason
                        ) { success, error in
                            if success {
                                print("face")
                                DispatchQueue.main.async {
                                    let vc = UIStoryboard.init(name: "BaseTabbar", bundle: nil).instantiateViewController(withIdentifier: "BaseTabbarViewController") as! BaseTabbarViewController
                                    appdelegate.window?.rootViewController = vc
                                }
                            } else {
                                
                                print(error?.localizedDescription)

                            }
                        }
                    } else {
                        let vc = UIStoryboard.init(name: "BaseTabbar", bundle: nil).instantiateViewController(withIdentifier: "BaseTabbarViewController") as! BaseTabbarViewController
                        appdelegate.window?.rootViewController = vc
                    }
                } else {
                    let coordinator = WelcomeCoordinator.init(navigationController: UINavigationController.init())
                    appdelegate.window?.rootViewController = UINavigationController.init(rootViewController: coordinator.getMainView())
                }
               
                
            }
        }
        
    }
}

