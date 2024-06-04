//
//  SendWithUsernameViewController.swift
//  Pebble
//
//  Created by macbookPro on 25/07/2022.
//

import UIKit
import Alamofire

class SendWithUsernameViewController: UIViewController {

    @IBOutlet weak var usernameTitle: UILabel!
    @IBOutlet weak var enterTITLE: UILabel!
    @IBOutlet weak var existsStack: UIStackView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var usernameContainer: UIView!
    @IBOutlet weak var usernameField: UITextField!
    
    var model: ProfileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        nextBtn.addCornerRadius(16)
        backBtn.setAttributedTitle(NSAttributedString.init(string: "Back", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 16)!]), for: .normal)
        existsStack.isHidden = true
        validate()
        usernameField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        
        usernameContainer.addCornerRadius(16)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTheme()
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currenTheme.backgroundColor
        usernameField.textColor = currenTheme.mainTextColor
        usernameContainer.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor.withAlphaComponent(0.4))
        self.backBtn.tintColor = currenTheme.mainTextColor
        self.nextBtn.tintColor = currenTheme.backgroundColor
        self.enterTITLE.textColor = currenTheme.mainTextColor
        self.usernameTitle.textColor = currenTheme.mainTextColor
        self.nextBtn.backgroundColor = currenTheme.mainButtonColor
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "SendAmount", bundle: nil).instantiateViewController(withIdentifier: "SendAmountViewController") as! SendAmountViewController
        vc.phone = self.usernameField.text
        vc.model = self.model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func textChanged(_ sender: UITextField) {
        self.checkAvailability(sender.text ?? "")
    }
    
    func checkAvailability(_ username: String) {
        self.showProgressHud()
        let url = "account/check-username"
        let param: [String: Any] = ["username": username]
        NetworkManager.shared.request(LoginModel.self, urlExt: url, method: .post, param: param, encoding: URLEncoding.default, headers: HTTPHeaders.init()) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                self.existsStack.isHidden = true
                self.validate()
            case .failure(let error):
                self.existsStack.isHidden = false
                self.validate()
                break
            }
        }
    }
    
    func validate() {
         !existsStack.isHidden  ? nextBtn.enable() : nextBtn.disable()
    }
}
