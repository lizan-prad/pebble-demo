//
//  CreatPasswordViewController.swift
//  Pebble
//
//  Created by macbookPro on 20/08/2022.
//

import UIKit
import Alamofire

class CreatPasswordViewController: UIViewController {

    @IBOutlet weak var confirmTitle: UILabel!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var createTitle: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorPassword: UILabel!
    @IBOutlet weak var createBtn: UIButton!
    
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var errorConfirmPassword: UILabel!
    
    var pin: String?
    var verificationId: String?
    var phone: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.setTheme()
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currenTheme.backgroundColor
        
        createTitle.textColor = currenTheme.mainTextColor
        passwordView.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor.withAlphaComponent(0.4))
        confirmPasswordView.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor.withAlphaComponent(0.4))
       
        self.backBtn.tintColor = currenTheme.mainTextColor
        
        self.createBtn.tintColor = currenTheme.backgroundColor
        self.passwordTitle.textColor = currenTheme.mainTextColor
        self.confirmTitle.textColor = currenTheme.mainTextColor
        
        self.passwordField.textColor = currenTheme.mainTextColor
        self.confirmPasswordField.textColor = currenTheme.mainTextColor
       
       
        self.createBtn.backgroundColor = currenTheme.mainButtonColor
        createBtn.disable()
    }
    
    private func setup() {
        backBtn.setAttributedTitle(NSAttributedString.init(string: "Back", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 16)!]), for: .normal)
        errorPassword.isHidden = true
        errorConfirmPassword.isHidden = true
        
        
        createBtn.addCornerRadius(16)
        
        
        passwordView.addBorder(ColorConfig.baseColor.withAlphaComponent(0.4))
        confirmPasswordView.addBorder(ColorConfig.baseColor.withAlphaComponent(0.4))
      
        passwordView.addCornerRadius(16)
        confirmPasswordView.addCornerRadius(16)

        passwordField.addTarget(self, action: #selector(passCHanged(_:)), for: .editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(confirmPassChanged(_:)), for: .editingChanged)
        
        createBtn.addTarget(self, action: #selector(createAction), for: .touchUpInside)
        
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        if (sender.text != self.passwordField.text) {
            self.errorConfirmPassword.text = "Your password donot match."
            self.errorConfirmPassword.isHidden = false
        } else {
            self.errorConfirmPassword.text = ""
            self.errorConfirmPassword.isHidden = true
        }
    }

    func validate() {
        (passwordField.text?.count ?? 0) >= 8 && confirmPasswordField.text == passwordField.text  ? createBtn.enable() : createBtn.disable()
    }
    
    @objc func createAction() {
        self.showProgressHud()
        let url = "account/reset-password"
        let param: [String: Any] = [
            "mobile": self.phone ?? "",
            "password": self.passwordField.text ?? "",
            "verification_id": self.verificationId ?? "",
            "verification_code": self.pin ?? ""
        ]
        NetworkManager.shared.request(RegisterModel.self, urlExt: url, method: .patch, param: param, encoding: URLEncoding.default, headers:HTTPHeaders.init()) { result in
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
