//
//  SendWithPhoneViewController.swift
//  Pebble
//
//  Created by macbookPro on 25/07/2022.
//

import UIKit
import PhoneNumberKit
import CountryList
import Alamofire

class SendWithPhoneViewController: UIViewController {
    @IBOutlet weak var phoneTitle: UILabel!
    @IBOutlet weak var entertitle: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var flagBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var phoneFIeld: PhoneNumberTextField!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var phoneExtensionLabel: UILabel!
    @IBOutlet weak var phoneView: UIView!
    
    var countryList = CountryList()
    var selectedCOuntry: Country? {
        didSet {
            self.phoneExtensionLabel.text = "+\(selectedCOuntry?.phoneExtension ?? "")"
        }
    }
    
    var model: ProfileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupPhoneField()
        nextBtn.disable()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTheme()
    }
    
    private func setup() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.errorLabel.isHidden = true
        backBtn.setAttributedTitle(NSAttributedString.init(string: "Back", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 16)!]), for: .normal)
        nextBtn.addCornerRadius(16)
        self.selectedCOuntry = countryList.getCountry(code: self.phoneFIeld.currentRegion)
        countryList.delegate = self

        
     
        phoneView.addCornerRadius(16)
     
        flagBtn.addTarget(self, action: #selector(openCountryList), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currenTheme.backgroundColor
        phoneFIeld.textColor = currenTheme.mainTextColor
        phoneView.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor.withAlphaComponent(0.4))
        self.backBtn.tintColor = currenTheme.mainTextColor
        self.nextBtn.tintColor = currenTheme.backgroundColor
        self.entertitle.textColor = currenTheme.mainTextColor
        self.flagBtn.tintColor = currenTheme.mainTextColor
        self.phoneTitle.textColor = currenTheme.mainTextColor
        self.nextBtn.backgroundColor = currenTheme.mainButtonColor
    }
    
    func checkPhone(_ phone: String) {
        
        self.showProgressHud()
        NetworkManager.shared.request(AssetModel.self, urlExt: "users/\(phone.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "") )", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let models):
                self.errorLabel.isHidden = true
                self.nextBtn.enable()
                break
            case .failure(let error):
                self.errorLabel.isHidden = false
                self.nextBtn.disable()
//                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
            }
        }
    }
    
    @objc func nextAction() {
        let vc = UIStoryboard.init(name: "SendAmount", bundle: nil).instantiateViewController(withIdentifier: "SendAmountViewController") as! SendAmountViewController
        vc.phone = "\(self.phoneExtensionLabel.text ?? "")\(self.phoneFIeld.phoneNumber?.nationalNumber ?? 0)"
        vc.model = self.model
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    @objc func textCHanged() {
        self.errorLabel.isHidden = true
        if !phoneFIeld.isValidNumber {
            //               self.errorLabel.text = StringConstants.ErrorMessages.invalidNumber
        } else {
//            self.errorLabel.text = ""
            
        }
//        phoneFIeld.isValidNumber ? nextBtn.enable() : nextBtn.disable()
        if phoneFIeld.isValidNumber {
            self.checkPhone("\(self.phoneExtensionLabel.text ?? "")\(self.phoneFIeld.phoneNumber?.nationalNumber ?? 0)")
        }
    }

    @objc func openCountryList() {
        let vc = UIStoryboard.init(name: "CountryList", bundle: nil).instantiateViewController(withIdentifier: "CountryListViewController") as! CountryListViewController
//        let navController = UINavigationController(rootViewController: countryList)
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

extension SendWithPhoneViewController: CountryListDelegate, UIAdaptivePresentationControllerDelegate {
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
