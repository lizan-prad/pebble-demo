//
//  ForgotPasswordViewController.swift
//  Pebble
//
//  Created by macbookPro on 20/08/2022.
//

import UIKit
import PhoneNumberKit
import CountryList
import Alamofire

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var phoneTitle: UILabel!
    @IBOutlet weak var enterTitl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var flagBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var phoneFIeld: PhoneNumberTextField!
    @IBOutlet weak var phoneExtensionLabel: UILabel!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var resetBtn: UIButton!
    
    var countryList = CountryList()
    var selectedCOuntry: Country? {
        didSet {
            self.phoneExtensionLabel.text = "+\(selectedCOuntry?.phoneExtension ?? "")"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupPhoneField()
        resetBtn.disable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.setTheme()
    }
    
    private func setup() {
        backBtn.setAttributedTitle(NSAttributedString.init(string: "Back", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 16)!]), for: .normal)
        self.errorLabel.isHidden = true
        resetBtn.disable()
        resetBtn.addCornerRadius(16)
        self.selectedCOuntry = countryList.getCountry(code: self.phoneFIeld.currentRegion)
        countryList.delegate = self
        
       
        
        phoneView.addCornerRadius(16)
        phoneExtensionLabel.isUserInteractionEnabled = true
        flagBtn.addTarget(self, action: #selector(openCountryList), for: .touchUpInside)
        resetBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currenTheme.backgroundColor
        phoneFIeld.textColor = currenTheme.mainTextColor
        phoneView.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor.withAlphaComponent(0.4))
        self.backBtn.tintColor = currenTheme.mainTextColor
        self.resetBtn.tintColor = currenTheme.backgroundColor
        self.enterTitl.textColor = currenTheme.mainTextColor
        self.flagBtn.tintColor = currenTheme.mainTextColor
        self.phoneTitle.textColor = currenTheme.mainTextColor
        self.resetBtn.backgroundColor = currenTheme.mainButtonColor
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
        phoneFIeld.isValidNumber ? resetBtn.enable() : resetBtn.disable()
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
    
    
    @objc func loginAction() {
        self.showProgressHud()
        let url = "account/mobile/send-verification-code"
        let param: [String: Any] = ["mobile": (phoneExtensionLabel.text?.replacingOccurrences(of: "+", with: "") ?? "") + String(phoneFIeld.phoneNumber?.nationalNumber ?? 0)]
        NetworkManager.shared.request(RegisterModel.self, urlExt: url, method: .post, param: param, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                let vc = UIStoryboard.init(name: "Otp", bundle: nil).instantiateViewController(withIdentifier: "OtpViewController") as! OtpViewController
                
                vc.phoneNo = (self.phoneExtensionLabel.text ?? "") + (self.phoneFIeld.phoneNumber?.numberString ?? "")
                vc.isRegister = false
                vc.isReset = true
                vc.actualPhone = (self.phoneExtensionLabel.text?.replacingOccurrences(of: "+", with: "") ?? "") + String(self.phoneFIeld.phoneNumber?.nationalNumber ?? 0)
                vc.didGetPin = { pin in
                    let vc = UIStoryboard.init(name: "CreatePassword", bundle: nil).instantiateViewController(withIdentifier: "CreatPasswordViewController") as! CreatPasswordViewController
                    vc.phone = (self.phoneExtensionLabel.text?.replacingOccurrences(of: "+", with: "") ?? "") + String(self.phoneFIeld.phoneNumber?.nationalNumber ?? 0)
                    vc.pin = pin
                    vc.verificationId = model.verificationId
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                self.navigationController?.pushViewController(vc, animated: true)
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
   
 

}


extension ForgotPasswordViewController: CountryListDelegate, UIAdaptivePresentationControllerDelegate {
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
