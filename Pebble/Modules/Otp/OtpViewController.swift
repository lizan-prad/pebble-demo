//
//  OtpViewController.swift
//  Pebble
//
//  Created by macbookPro on 15/07/2022.
//

import UIKit
import SVPinView
import Alamofire

class OtpViewController: UIViewController {
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var confirmTitle: UILabel!
    @IBOutlet weak var enterTitle: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var resendStack: UIStackView!
    @IBOutlet weak var timerStack: UIStackView!
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var pinField: SVPinView!
    
    var password: String?
    var verificationId: String?
    var phoneNo: String?
    var actualPhone: String?
    var timer = 60
    var pin: String?
    var username: String?
    
    var isRegister = true
    var isReset = false
    
    var didGetPin: ((String) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        errorLabel.isHidden = true
        self.enterBtn.disable()
        pinField.style = .box
        pinField.keyboardType = .numberPad
        pinField.becomeFirstResponderAtIndex = 0
        pinField.didFinishCallback = { [weak self] pin in
            self?.enterBtn.enable()
            self?.pin = pin
        }
        self.startTimer()
        enterBtn.addTarget(self, action: #selector(enterAction), for: .touchUpInside)
    }
    
    func setTheme() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currentTheme.backgroundColor
        self.backBtn.tintColor = currentTheme.mainTextColor
        self.resendBtn.tintColor = currentTheme.backgroundColor
        self.enterBtn.backgroundColor = currentTheme.mainButtonColor
        self.enterBtn.tintColor = currentTheme.backgroundColor
        enterTitle.textColor = currentTheme.mainTextColor
        phone.textColor = currentTheme.mainTextColor
        timerLabel.textColor = currentTheme.mainTextColor
        confirmTitle.textColor = currentTheme.mainTextColor
        pinField.activeBorderLineColor = currentTheme.mainTextColor!
        pinField.textColor = currentTheme.mainTextColor!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTheme()
    }
    
    @objc func enterAction() {
        if isRegister {
        self.validatePin(self.pin ?? "")
        } else {
            if isReset {
                self.didGetPin?(self.pin ?? "")
            } else {
            self.didGetPin?(self.pin ?? "")
            self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func validatePin(_ pin: String) {
        self.errorLabel.isHidden = true
        let param: [String: Any] = [
            "mobile": phoneNo?.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "") ?? "",
            "password": password ?? "",
            "username": username ?? "",
            "verification_id": verificationId ?? "",
            "verification_code": pin
        ]
        
        NetworkManager.shared.request(RegisterModel.self, urlExt: "account/register", method: .post, param: param, encoding: URLEncoding.default, headers: nil) { result in
            switch result {
            case .success(let model):
                self.showToastMsg("Registration success", state: .success, location: .bottom)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    let nav = UINavigationController.init(rootViewController: vc)
                    appdelegate.window?.rootViewController = nav
                }
                break
            case .failure(let error):
                self.pinField.borderLineColor = .red
                self.pinField.refreshView()
                self.enterBtn.disable()
                self.errorLabel.isHidden = false
                self.errorLabel.text = error.localizedDescription
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
                break
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendAction(_ sender: Any) {
        self.resendCode()
    }
    
    func resendCode() {
        self.showProgressHud()
        let url = "account/mobile/send-verification-code"
        let param: [String: Any] = ["country_code":  UserDefaults.standard.string(forKey: "EXT") ?? "",
                                    "mobile": UserDefaults.standard.string(forKey: "MOBILE") ?? ""]
        NetworkManager.shared.request(RegisterModel.self, urlExt: url, method: .post, param: param, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                self.startTimer()
            case .failure(let error):
                break
            }
        }
    }
    
    func startTimer() {
        self.timerStack.isHidden = false
        self.resendStack.isHidden = true
        self.timer = 60
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timer = self.timer - 1
            self.timerLabel.text = "00:\(self.timer)"
            if self.timer == 0 {
                timer.invalidate()
                self.timerStack.isHidden = true
                
                self.resendStack.isHidden = false
            }
        }
    }
    
    func openFaceID() {
        let vc = UIStoryboard.init(name: "SecurityFace", bundle: nil).instantiateViewController(withIdentifier: "SecurityFaceViewController") as! SecurityFaceViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setup() {
        self.phone.text = self.phoneNo
        enterBtn.addCornerRadius(16)
        backBtn.setAttributedTitle(NSAttributedString.init(string: "Back", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 16)!]), for: .normal)
    }


}
