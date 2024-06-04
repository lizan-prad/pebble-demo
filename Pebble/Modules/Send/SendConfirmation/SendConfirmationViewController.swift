//
//  SendConfirmationViewController.swift
//  Pebble
//
//  Created by macbookPro on 06/08/2022.
//

import UIKit
import Alamofire
import SDWebImage

class SendConfirmationViewController: UIViewController {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var sendTitle: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var profileImageContainer: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var initialP: UILabel!
    @IBOutlet weak var initialContainer: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var detailContainer: UIView!
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var phone: String?
    var amount: String?
    var displayPhone: String?
    var primary: AssetModel?
    var model: ProfileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setup() {
        profileImage.sd_setImage(with: URL.init(string: "https://cdn.plutopay.co/\(model?.avatar ?? "")"), placeholderImage: nil, options: .refreshCached, context: nil)
        profileImage.rounded()
        self.initialContainer.setStandardShadow()
        self.initialContainer.rounded()
        initialContainer.backgroundColor = getRandomAvatarColor()
        initialP.textColor = .white
        self.initialP.text = phone?.prefix(1).uppercased()
        self.backBtn.isHidden = true
        sendBtn.setAttributedTitle(NSAttributedString.init(string: "Send", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 18)!]), for: .normal)
        cancelBtn.setAttributedTitle(NSAttributedString.init(string: "Cancel", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 18)!]), for: .normal)
        backBtn.setAttributedTitle(NSAttributedString.init(string: "Back", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 16)!]), for: .normal)
        profileImageContainer.rounded()
        profileImageContainer.addBorder(UIColor.init(hex: "636573").withAlphaComponent(0.5))
        detailContainer.addCornerRadius(12)
        sendBtn.addCornerRadius(16)
        self.username.text = displayPhone ?? phone
        phoneLabel.text = phone
        amountLabel.text = "$\(amount ?? "")"
        self.tokenLabel.text = primary?.symbol
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTheme()
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currenTheme.backgroundColor
        self.container.backgroundColor = currenTheme.backgroundColor
        username.textColor = currenTheme.mainTextColor
        detailContainer.backgroundColor = (currentTheme == .dark ? currenTheme.marginColor : UIColor.init(hex: "F9F9FE"))
        self.backBtn.tintColor = currenTheme.mainTextColor
        self.sendBtn.tintColor = currenTheme.backgroundColor
        self.cancelBtn.tintColor = currenTheme.mainTextColor
        self.sendTitle.textColor = currenTheme.mainTextColor
        self.amountLabel.textColor = currenTheme.mainTextColor
        self.phoneLabel.textColor = currenTheme.mainTextColor
        self.tokenLabel.textColor = currenTheme.mainTextColor
        self.sendBtn.backgroundColor = currenTheme.mainButtonColor
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func sendAction(_ sender: Any) {
        if let _ = UserDefaults.standard.value(forKey: "PIN") as? String {
            let vc = UIStoryboard.init(name: "SetupPin", bundle: nil).instantiateViewController(withIdentifier: "SetupPinViewController") as! SetupPinViewController
            vc.defaultMode = .verify
            vc.state = "V"
            vc.didSetPin = { code in
                let param: [String: Any] = [
                    "to": self.displayPhone == nil ? self.phone ?? "" : self.phone?.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "") ?? "",
                    "amount": self.amount ?? "",
                    "asset_id": self.primary?.id ?? 0,
                    "pincode": code
                ]
                self.showProgressHud()
                NetworkManager.shared.request(TransactionModel.self, urlExt: "account/withdraws", method: .post, param: param, encoding: URLEncoding.default, headers: nil) { result in
                    self.hideProgressHud()
                    switch result {
                    case .success(let model):
                        self.showToastMsg("Withdraw confirming...", state: .success, location: .bottom)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                            self.dismiss(animated: true)
                            let vc = UIStoryboard.init(name: "TransactionReciept", bundle: nil).instantiateViewController(withIdentifier: "TransactionRecieptViewController") as! TransactionRecieptViewController
                            vc.model = model
                            vc.isReciept = true
                            vc.isSendRecieve = true
                            vc.didClose = {
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                            vc.didLoad = {
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                            self.present(vc, animated: true)
                        }
                        break
                    case .failure(let error):
                        self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
                    }
                }
            }
            self.present(UINavigationController.init(rootViewController: vc), animated: true)
        } else {
            self.sendVerification()
        }
    }
    
    func sendVerification() {
        self.showProgressHud()
        let url = "account/mobile/send-verification-code"
        let param: [String: Any] = [
            "country_code":  UserDefaults.standard.string(forKey: "EXT") ?? "",
            "mobile": UserDefaults.standard.string(forKey: "MOBILE") ?? ""]
        NetworkManager.shared.request(RegisterModel.self, urlExt: url, method: .post, param: param, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                let vc = UIStoryboard.init(name: "Otp", bundle: nil).instantiateViewController(withIdentifier: "OtpViewController") as! OtpViewController
                vc.verificationId = model.verificationId
                vc.phoneNo = UserDefaults.standard.string(forKey: "MOBILE")
                vc.actualPhone = UserDefaults.standard.string(forKey: "MOBILE")
                vc.isRegister = false
                vc.didGetPin = { pin in
                    self.withdrawCall(pin, verifID: model.verificationId ?? "")
                }
                self.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
            }
        }
    }
    
    func withdrawCall(_ pin: String, verifID: String) {
        let param: [String: Any] = [
            "to": displayPhone == nil ? phone ?? "" : phone?.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "") ?? "",
            "amount": self.amount ?? "",
            "asset_id": self.primary?.id ?? 0,
            "verification_id": verifID,
            "verification_code": pin
        ]
        self.showProgressHud()
        NetworkManager.shared.request(TransactionModel.self, urlExt: "account/withdraws", method: .post, param: param, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                self.showToastMsg("Withdraw confirming...", state: .success, location: .bottom)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.dismiss(animated: true)
                    let vc = UIStoryboard.init(name: "TransactionReciept", bundle: nil).instantiateViewController(withIdentifier: "TransactionRecieptViewController") as! TransactionRecieptViewController
                    vc.model = model
                    vc.isReciept = true
                    vc.isSendRecieve = true
                    vc.didClose = {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    vc.didLoad = {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    self.present(vc, animated: true)
                }
                break
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
            }
        }
    }
    
}
