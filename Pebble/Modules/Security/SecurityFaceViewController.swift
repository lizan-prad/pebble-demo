//
//  SecurityFaceViewController.swift
//  EtherWallet
//
//  Created by Macbook Pro on 15/06/2022.
//

import UIKit
import LocalAuthentication
import Alamofire

func biometricType() -> BiometricType {
    let authContext = LAContext()
    if #available(iOS 11, *) {
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch(authContext.biometryType) {
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return .face
        }
    } else {
        return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
    }
}

enum BiometricType {
    case none
    case touch
    case face
}

class SecurityFaceViewController: UIViewController {

    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var setupBtn: UIButton!
    @IBOutlet weak var bioDesc: UILabel!
    @IBOutlet weak var bioTitle: UILabel!
    @IBOutlet weak var bioImage: UIImageView!
    
    let context = LAContext()
    
    var pin: String?
    
    var status = true
    
    var isFromSettings = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBtn.setAttributedTitle(NSAttributedString.init(string: "Set Up Now", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 18)!]), for: .normal)
        skipBtn.setAttributedTitle(NSAttributedString.init(string: "Skip", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 18)!]), for: .normal)
        setupBtn.addCornerRadius(16)
        skipBtn.addCornerRadius(16)
        bioImage.image = UIImage.init(named: biometricType() == .face ? "faceframe" : "fingerframe")
        bioDesc.text = "Set up a \(biometricType() == .face ? "Face ID" : "Touch ID") so that you don't need to enter a code every time you enter."
        bioTitle.text = "Set Up \(biometricType() == .face ? "Face ID" : "Touch ID")"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTheme()
    }
    
    func setTheme() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.bioImage.tintColor = currentTheme.mainTextColor
        self.bioTitle.textColor = currentTheme.mainTextColor
        self.view.backgroundColor = currentTheme.backgroundColor
        self.skipBtn.backgroundColor = currentTheme.marginColor
        self.skipBtn.tintColor = currentTheme.mainTextColor
        self.setupBtn.backgroundColor = currentTheme.mainButtonColor
        self.setupBtn.tintColor = currentTheme.backgroundColor
    }
    
    @IBAction func setupAction(_ sender: Any) {
        setupBiometrics()
    }
    
    func setupBiometrics() {
        
        let reason = "Log in with Face ID"
        context.evaluatePolicy(
            // .deviceOwnerAuthentication allows
            // biometric or passcode authentication
            .deviceOwnerAuthentication,
            localizedReason: reason
        ) { success, error in
            if success {
                print("face")
                DispatchQueue.main.async {
                    UserDefaults.standard.set("Y", forKey: "FACE")
                    if self.isFromSettings {
                        self.dismiss(animated: true)
                    } else {
                        self.fetchProfile()
                    }
                }
            } else {
                
                print(error?.localizedDescription)

            }
        }
    }
    
    func fetchProfile() {
        let vc = UIStoryboard.init(name: "BaseTabbar", bundle: nil).instantiateViewController(withIdentifier: "BaseTabbarViewController") as! BaseTabbarViewController
        appdelegate.window?.rootViewController = vc
    }
    
    @IBAction func skipAction(_ sender: Any) {
        if isFromSettings {
            self.dismiss(animated: true)
        } else {
        self.fetchProfile()
        }
    }
    

}
