//
//  ChangePasswordViewController.swift
//  Pebble
//
//  Created by macbookPro on 20/08/2022.
//

import UIKit
import Alamofire

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var confirmTitle: UILabel!
    @IBOutlet weak var newTitle: UILabel!
    @IBOutlet weak var currentTitle: UILabel!
    @IBOutlet weak var changeTitle: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorPassword: UILabel!
    
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var errorNewPassword: UILabel!
    
    @IBOutlet weak var createBtn: UIButton!
    
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var errorConfirmPassword: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.setTheme()
    }
    
    private func setup() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        backBtn.setAttributedTitle(NSAttributedString.init(string: "Back", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 16)!]), for: .normal)
        errorPassword.isHidden = true
        errorNewPassword.isHidden = true
        errorConfirmPassword.isHidden = true
        
        createBtn.disable()
        createBtn.addCornerRadius(16)
      
        passwordView.addCornerRadius(16)
        newPasswordView.addCornerRadius(16)
        confirmPasswordView.addCornerRadius(16)

        passwordField.addTarget(self, action: #selector(passCHanged(_:)), for: .editingChanged)
        newPasswordField.addTarget(self, action: #selector(newPassCHanged(_:)), for: .editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(confirmPassChanged(_:)), for: .editingChanged)
        
        createBtn.addTarget(self, action: #selector(createAction), for: .touchUpInside)
        
    }
    
    
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currenTheme.backgroundColor
        
        changeTitle.textColor = currenTheme.mainTextColor
        passwordView.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor.withAlphaComponent(0.4))
        newPasswordView.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor.withAlphaComponent(0.4))
        confirmPasswordView.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor.withAlphaComponent(0.4))
       
        self.backBtn.tintColor = currenTheme.mainTextColor
        
        self.createBtn.tintColor = currenTheme.backgroundColor
        self.currentTitle.textColor = currenTheme.mainTextColor
        self.newTitle.textColor = currenTheme.mainTextColor
        self.confirmTitle.textColor = currenTheme.mainTextColor
        self.changeTitle.textColor = currenTheme.mainTextColor
        self.passwordField.textColor = currenTheme.mainTextColor
        self.newPasswordField.textColor = currenTheme.mainTextColor
        self.confirmPasswordField.textColor = currenTheme.mainTextColor
        self.createBtn.backgroundColor = currenTheme.mainButtonColor
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func newPassCHanged(_ sender: UITextField) {
        validate()
        if (sender.text?.count ?? 0) < 8 {
            self.errorNewPassword.text = "Password must be 8 characters."
            self.errorNewPassword.isHidden = false
        } else {
            self.errorNewPassword.text = ""
            self.errorNewPassword.isHidden = true
        }
    }

    @objc func passCHanged(_ sender: UITextField) {
        validate()
        if (sender.text?.count ?? 0) < 8 {
            self.errorPassword.text = "Password must be 8 characters."
            self.errorPassword.isHidden = false
        } else {
            self.errorPassword.text = ""
            self.errorPassword.isHidden = true
        }
    }
    
    @objc func confirmPassChanged(_ sender: UITextField) {
        validate()
        if (sender.text != self.newPasswordField.text) {
            self.errorConfirmPassword.text = "Your password donot match."
            self.errorConfirmPassword.isHidden = false
        } else {
            self.errorConfirmPassword.text = ""
            self.errorConfirmPassword.isHidden = true
        }
    }

    func validate() {
        (passwordField.text?.count ?? 0) >= 8 && (newPasswordField.text?.count ?? 0) >= 8 && confirmPasswordField.text == newPasswordField.text  ? createBtn.enable() : createBtn.disable()
    }
    
    @objc func createAction() {
        self.showProgressHud()
        let url = "account/reset-password"
        let param: [String: Any] = [
            "old_password": self.passwordField.text ?? "",
            "new_password": self.confirmPasswordField.text ?? ""
        ]
        NetworkManager.shared.request(RegisterModel.self, urlExt: url, method: .post, param: param, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                self.showToastMsg("Password reset successfull.", state: .success, location: .bottom)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.dismiss(animated: true) {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            case .failure(let error):
                
                    self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
                
                break
            }
        }
    }
}
