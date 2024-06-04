//
//  WelcomeViewController.swift
//  EtherWallet
//
//  Created by test on 12/04/2022.
//

import UIKit


class WelcomeViewController: UIViewController, Storyboarded {

    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var blockTitle: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var getstartedBtn: UIButton!
//    @IBOutlet weak var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    var pin: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setTheme()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.title = ""
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setTheme() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.logo.tintColor = currentTheme.mainTextColor
        self.blockTitle.textColor = currentTheme.mainTextColor
        self.view.backgroundColor = currentTheme.backgroundColor
        self.getstartedBtn.tintColor = currentTheme.backgroundColor
        self.getstartedBtn.backgroundColor = currentTheme.mainButtonColor
        self.signUpBtn.tintColor = currentTheme.mainTextColor
    }
    
    func setup() {
        getstartedBtn.addCornerRadius(16)
        signUpBtn.addCornerRadius(16)
    }

    @IBAction func getStartedAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let nav = UINavigationController.init(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true)

    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Registration", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        let nav = UINavigationController.init(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true)
    }
    
}
extension UIViewController {
    func alertWithTextField(title: String? = nil, message: String? = nil, placeholder: String? = nil, completion: @escaping ((String,String) -> Void) = { _,_  in }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField() { newTextField in
            newTextField.placeholder = placeholder
        }
        alert.addTextField() { newTextField in
            newTextField.placeholder = "Password"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in completion("","") })
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            if
                let textFields = alert.textFields,
                let tf = textFields.first, let tf2 = textFields.last,
                let result = tf.text
            { completion(result, tf2.text ?? "") }
            else
            { completion("", "") }
        })
        self.present(alert, animated: true)
    }

}
