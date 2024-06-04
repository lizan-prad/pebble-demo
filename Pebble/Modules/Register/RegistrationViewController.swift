//
//  RegistrationViewController.swift
//  Pebble
//
//  Created by macbookPro on 17/07/2022.
//

import UIKit
import MBRadioCheckboxButton
import PhoneNumberKit
import CountryList
import Alamofire

class RegistrationViewController: UIViewController, CheckboxButtonDelegate {
    
    
    @IBOutlet weak var dropBtn: UIButton!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var loginTitle: UIButton!
    @IBOutlet weak var agreementTitle: UILabel!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var usernameTitle: UILabel!
    @IBOutlet weak var phoneTitle: UILabel!
    @IBOutlet weak var enterTitle: UILabel!
    @IBOutlet weak var errorPassword: UILabel!
    @IBOutlet weak var flagBtn: UIButton!
    @IBOutlet weak var availableStack: UIStackView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var phoneFIeld: PhoneNumberTextField!
    @IBOutlet weak var phoneExtensionLabel: UILabel!
    @IBOutlet weak var iAgreeCheck: CheckboxButton!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var phoneView: UIView!
    
    @IBOutlet weak var usernameErrorLabel: UILabel!
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userNameContainer: UIView!
   
    var countryList = CountryList()
    var selectedCOuntry: Country? {
        didSet {
            self.phoneExtensionLabel.text = "+\(selectedCOuntry?.phoneExtension ?? "")"
        }
    }
    
    var isFromLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupPhoneField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.setTheme()
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currenTheme.backgroundColor
        self.container.backgroundColor = currenTheme.backgroundColor
        phoneFIeld.textColor = currenTheme.mainTextColor
        phoneView.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor.withAlphaComponent(0.4))
        passwordField.textColor = currenTheme.mainTextColor
        passwordView.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor.withAlphaComponent(0.4))
        self.createBtn.tintColor = currenTheme.mainTextColor
        userNameField.textColor = currenTheme.mainTextColor
        userNameContainer.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor.withAlphaComponent(0.4))
        self.enterTitle.textColor = currenTheme.mainTextColor
        self.phoneTitle.textColor = currenTheme.mainTextColor
        self.usernameTitle.textColor = currenTheme.mainTextColor
        self.passwordTitle.textColor = currenTheme.mainTextColor
        self.createBtn.backgroundColor = currenTheme.mainButtonColor
        self.createBtn.tintColor = currenTheme.backgroundColor
        self.dropBtn.tintColor = currenTheme.mainTextColor
        self.iAgreeCheck.tintColor = currenTheme.mainTextColor
        agreementTitle.textColor = currenTheme.mainTextColor
        self.loginTitle.tintColor = currenTheme.mainTextColor
    }
    
    private func setup() {
        errorLabel.isHidden = true
        errorPassword.isHidden = true
        createBtn.disable()
        createBtn.addCornerRadius(16)
        iAgreeCheck.delegate = self
        self.selectedCOuntry = countryList.getCountry(code: self.phoneFIeld.currentRegion)
        countryList.delegate = self
        passwordView.addBorder(ColorConfig.baseColor.withAlphaComponent(0.4))
        phoneView.addBorder(ColorConfig.baseColor.withAlphaComponent(0.4))
        passwordView.addCornerRadius(16)
        phoneView.addCornerRadius(16)
//        phoneExtensionLabel.isUserInteractionEnabled = true
//        phoneExtensionLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openCountryList)))
        passwordField.addTarget(self, action: #selector(passCHanged(_:)), for: .editingChanged)
        userNameField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        userNameContainer.addBorder(ColorConfig.baseColor.withAlphaComponent(0.4))
        userNameContainer.addCornerRadius(16)
        userNameField.keyboardType = .alphabet
        self.availableStack.isHidden = true
        createBtn.addTarget(self, action: #selector(createAction), for: .touchUpInside)
        flagBtn.addTarget(self, action: #selector(openCountryList), for: .touchUpInside)
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
                self.availableStack.isHidden = false
                self.validate()
                print(model.token)
            case .failure(let error):
                self.availableStack.isHidden = true
                self.validate()
                break
            }
        }
    }
    
    
    private func setupPhoneField() {
        phoneFIeld.withExamplePlaceholder = false
        phoneFIeld.textContentType = .telephoneNumber
        phoneFIeld.maxDigits = 12
        self.presentationController?.delegate = self
        phoneFIeld.addTarget(self, action: #selector(textCHanged), for: .editingChanged)

        self.selectedCOuntry = countryList.getCountry(code: self.phoneFIeld.currentRegion)
        self.flagBtn.setTitle(countryList.getCountry(code: self.phoneFIeld.currentRegion )?.flag ?? "", for: .normal)
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

    
    @objc func textCHanged() {
        validate()
        self.errorLabel.isHidden = true
        if !phoneFIeld.isValidNumber {
//            self.errorLabel.isHidden = false
            //               self.errorLabel.text = StringConstants.ErrorMessages.invalidNumber
        } else {
//            self.errorLabel.isHidden = true
//            self.errorLabel.text = ""
            
        }
//        phoneFIeld.isValidNumber ? createBtn.enable() : createBtn.disable()
    }
    
    func validate() {
        (phoneFIeld.isValidNumber && (passwordField.text?.count ?? 0) >= 8 && iAgreeCheck.isOn && !availableStack.isHidden)  ? createBtn.enable() : createBtn.disable()
    }
    
    @objc func createAction() {
        self.showProgressHud()
        let url = "account/mobile/send-verification-code"
        let param: [String: Any] = [
            "country_code": (phoneExtensionLabel.text?.replacingOccurrences(of: "+", with: "") ?? ""),
            "mobile": (phoneExtensionLabel.text?.replacingOccurrences(of: "+", with: "") ?? "") + String(phoneFIeld.phoneNumber?.nationalNumber ?? 0)]
        NetworkManager.shared.request(RegisterModel.self, urlExt: url, method: .post, param: param, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                let vc = UIStoryboard.init(name: "Otp", bundle: nil).instantiateViewController(withIdentifier: "OtpViewController") as! OtpViewController
                vc.verificationId = model.verificationId
                vc.password = self.passwordField.text
                vc.phoneNo = (self.phoneExtensionLabel.text ?? "") + (self.phoneFIeld.phoneNumber?.numberString ?? "")
                vc.username = self.userNameField.text
                vc.actualPhone = (self.phoneExtensionLabel.text?.replacingOccurrences(of: "+", with: "") ?? "") + String(self.phoneFIeld.phoneNumber?.nationalNumber ?? 0)
                self.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                if (error as NSError).domain == "uid" {
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = error.localizedDescription
                } else if (error as NSError).domain == "password" {
                    self.errorPassword.isHidden = false
                    self.errorPassword.text = error.localizedDescription
                } else {
                    self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
                }
                break
            }
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if isFromLogin {
            self.navigationController?.popViewController(animated: true)
        } else {
        let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.isFromRegister = true
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func openCountryList() {
        let vc = UIStoryboard.init(name: "CountryList", bundle: nil).instantiateViewController(withIdentifier: "CountryListViewController") as! CountryListViewController
        let navController = UINavigationController(rootViewController: countryList)
        vc.country = selectedCOuntry?.countryCode
        vc.didSelect = { code in
            let country = self.countryList.getCountry(code: code)
            self.selectedCOuntry = country
            self.flagBtn.setTitle(country?.flag ?? "", for: .normal)
            self.phoneFIeld._defaultRegion = country?.countryCode ?? ""
            self.phoneFIeld.partialFormatter.defaultRegion = country?.countryCode ?? ""
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func chechboxButtonDidSelect(_ button: CheckboxButton) {
        validate()
    }
    
    func chechboxButtonDidDeselect(_ button: CheckboxButton) {
        validate()
    }
    
}

extension RegistrationViewController: CountryListDelegate, UIAdaptivePresentationControllerDelegate {
    func selectedCountry(country: Country) {
        self.selectedCOuntry = country

        self.phoneFIeld._defaultRegion = country.countryCode
        self.phoneFIeld.partialFormatter.defaultRegion = country.countryCode
    }

    //MARK: Get the selected country
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }

//    func selectedCountry(country: Country) {
//
//
////        self.phoneField.updatePlaceholder()
//
//    }
}
