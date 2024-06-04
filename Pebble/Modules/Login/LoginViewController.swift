//
//  LoginViewController.swift
//  Pebble
//
//  Created by macbookPro on 14/07/2022.
//

import UIKit
import MBRadioCheckboxButton
import PhoneNumberKit
import CountryList
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var forgetBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var welcomeTitle: UILabel!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var phoneTitle: UILabel!
    @IBOutlet weak var dropBtn: UIButton!
    @IBOutlet weak var flagBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var phoneFIeld: PhoneNumberTextField!
    @IBOutlet weak var phoneExtensionLabel: UILabel!
//    @IBOutlet weak var iAgreeCheck: CheckboxButton!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var phoneView: UIView!
   
    var countryList = CountryList()
    var selectedCOuntry: Country? {
        didSet {
            self.phoneExtensionLabel.text = "+\(selectedCOuntry?.phoneExtension ?? "")"
        }
    }
    
    var isFromRegister = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupPhoneField()
        createBtn.disable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.setTheme()
    }
    
    private func setup() {
        self.errorLabel.isHidden = true
        createBtn.disable()
        createBtn.addCornerRadius(16)
        self.selectedCOuntry = countryList.getCountry(code: self.phoneFIeld.currentRegion)
        countryList.delegate = self
        
        passwordView.addCornerRadius(16)
        phoneView.addCornerRadius(16)
        phoneExtensionLabel.isUserInteractionEnabled = true
        flagBtn.addTarget(self, action: #selector(openCountryList), for: .touchUpInside)
        createBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
    }
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "ForgotPassword", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currenTheme.backgroundColor
        self.container.backgroundColor = currenTheme.backgroundColor
        phoneFIeld.textColor = currenTheme.mainTextColor
        phoneView.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor.withAlphaComponent(0.4))
        passwordField.textColor = currenTheme.mainTextColor
        passwordView.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor.withAlphaComponent(0.4))
        self.signUpBtn.tintColor = currenTheme.mainTextColor
        self.forgetBtn.tintColor = currenTheme.mainTextColor
        self.welcomeTitle.textColor = currenTheme.mainTextColor
        self.phoneTitle.textColor = currenTheme.mainTextColor
        self.passwordTitle.textColor = currenTheme.mainTextColor
        self.createBtn.backgroundColor = currenTheme.mainButtonColor
        self.createBtn.tintColor = currenTheme.backgroundColor
        self.dropBtn.tintColor = currenTheme.mainTextColor
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        if isFromRegister {
            self.navigationController?.popViewController(animated: true)
        } else {
            let vc = UIStoryboard.init(name: "Registration", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
            vc.isFromLogin = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func loginAction() {
        self.showProgressHud()
        let url = "account/login"
        let param: [String: Any] = ["uid": (phoneExtensionLabel.text?.replacingOccurrences(of: "+", with: "") ?? "") + String(phoneFIeld.phoneNumber?.nationalNumber ?? 0), "password": passwordField.text ?? ""]
        NetworkManager.shared.request(LoginModel.self, urlExt: url, method: .post, param: param, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                UserDefaults.standard.set(model.phone ?? "", forKey: "MOBILE")
                UserDefaults.standard.set((self.phoneExtensionLabel.text?.replacingOccurrences(of: "+", with: "")), forKey: "EXT")
                UserDefaults.standard.set(model.token, forKey: "AUTH")
                UserDefaults.standard.set(model.primaryAssetId ?? 0, forKey: "PA")
                self.openFaceID()
            case .failure(let error):
                if (error as NSError).domain == "uid" {
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = error.localizedDescription
                } else {
                    self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
                }
                break
            }
        }
    }
    
    func openFaceID() {
        if let _ =  UserDefaults.standard.string(forKey: "FACE") {
            let vc = UIStoryboard.init(name: "BaseTabbar", bundle: nil).instantiateViewController(withIdentifier: "BaseTabbarViewController") as! BaseTabbarViewController
            appdelegate.window?.rootViewController = vc
        } else {
            let vc = UIStoryboard.init(name: "SecurityFace", bundle: nil).instantiateViewController(withIdentifier: "SecurityFaceViewController") as! SecurityFaceViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func setupPhoneField() {
        phoneFIeld.withExamplePlaceholder = false
//        phoneFIeld.textContentType = .telephoneNumber
        phoneFIeld.maxDigits = 12
        self.presentationController?.delegate = self
        phoneFIeld.addTarget(self, action: #selector(textCHanged), for: .editingChanged)
        self.selectedCOuntry = countryList.getCountry(code: self.phoneFIeld.currentRegion)
        self.flagBtn.setTitle(countryList.getCountry(code: self.phoneFIeld.currentRegion )?.flag ?? "", for: .normal)
    }
    
    @objc func textCHanged() {
        self.errorLabel.isHidden = true
        if !phoneFIeld.isValidNumber {
//            self.errorLabel.text = "Invalid number!"
//            self.errorLabel.isHidden = false
            //               self.errorLabel.text = StringConstants.ErrorMessages.invalidNumber
        } else {
//            self.errorLabel.isHidden = true
//            self.errorLabel.text = ""
            
        }
        phoneFIeld.isValidNumber ? createBtn.enable() : createBtn.disable()
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
}

extension LoginViewController: CountryListDelegate, UIAdaptivePresentationControllerDelegate {
    //MARK: Get the selected country
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }

    func selectedCountry(country: Country) {
        self.selectedCOuntry = country

        self.phoneFIeld._defaultRegion = country.countryCode
        self.phoneFIeld.partialFormatter.defaultRegion = country.countryCode
        self.textCHanged()
//        self.phoneField.updatePlaceholder()

    }
}
