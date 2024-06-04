//
//  WithdrawViewController.swift
//  Pebble
//
//  Created by macbookPro on 27/07/2022.
//

import UIKit
import Alamofire

class WithdrawViewController: UIViewController {

    @IBOutlet weak var dropBtn: UIButton!
    @IBOutlet weak var maxTitle: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var amountTitle: UILabel!
    @IBOutlet weak var networkTitle: UILabel!
    @IBOutlet weak var addressTitle: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var networkField: UITextField!
    @IBOutlet weak var baseContainer: UIView!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    @IBOutlet weak var withdrawTitle: UILabel!
    @IBOutlet weak var tokenSymbol: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var withdrawBtn: UIButton!
    @IBOutlet weak var amountContainer: UIView!
    @IBOutlet weak var networkContainer: UIView!
    @IBOutlet weak var addressContaine: UIView!
    @IBOutlet weak var tokenBalance: UILabel!
    
    var balance: String?
    var asset: AssetModel?
    var network: Networks? {
        didSet {
            UserDefaults.standard.set(self.network?.name ?? "", forKey: "DEFCL")
            self.networkField.text = network?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        if addressLabel.text == "Long press to paste" {
            addressLabel.textColor = UIColor.init(hex: "9898A7")
        } else {
            addressLabel.textColor = ColorConfig.baseColor
        }
        self.network = self.asset?.networks?.first
        self.feeLabel.text = asset?.networks?.filter({$0.id == network?.id}).first?.withdraw_fee
        self.networkField.isUserInteractionEnabled = false
        addressLabel.isUserInteractionEnabled = true
        addressLabel.addGestureRecognizer(UILongPressGestureRecognizer.init(target: self, action: #selector(addAddress)))
        networkContainer.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(openNetwork)))
        amountField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        backBtn.setAttributedTitle(NSAttributedString.init(string: "Back", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 16)!]), for: .normal)
    }
    
    
    
    @objc func textChanged(_ sender: UITextField) {
        self.amountLabel.text = sender.text
        self.totalAmount.text = "\((Double(self.network?.withdraw_fee ?? "") ?? 0) + (Double(sender.text ?? "") ?? 0))"
        if (Double(sender.text ?? "") ?? 0) < (Double(asset?.networks?.first?.min_withdraw_amount ?? "") ?? 0) {
            self.withdrawBtn.disable()
        } else {
            self.withdrawBtn.enable()
        }
    }
    
    @objc func openNetwork() {
        let vc = UIStoryboard.init(name: "SelectNetwork", bundle: nil).instantiateViewController(withIdentifier: "SelectNetworkViewController") as! SelectNetworkViewController
        vc.networks = self.asset?.networks
        vc.didSetNetwork = { network in
            self.network = network
        }
        self.present(vc, animated: true)
    }
    
    @objc func addAddress() {
        self.addressLabel.text = UIPasteboard.general.string
    }

    func setup() {
        self.tokenBalance.text = "\(balance ?? "0.00")"
//        amountContainer.addBorder(ColorConfig.baseColor.withAlphaComponent(0.5))
//        networkContainer.addBorder(ColorConfig.baseColor.withAlphaComponent(0.5))
//        addressContaine.addBorder(ColorConfig.baseColor.withAlphaComponent(0.5))
        
        amountContainer.addCornerRadius(16)
        networkContainer.addCornerRadius(16)
        addressContaine.addCornerRadius(16)
        
        baseContainer.addCornerRadius(16)
        withdrawBtn.addCornerRadius(16)
        
        self.withdrawTitle.text = "Withdraw \(asset?.symbol ?? "")"
//        self.tokenBalance.text = ""
        tokenSymbol.text = asset?.symbol
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTheme()
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currenTheme.backgroundColor
        self.container.backgroundColor = currenTheme.backgroundColor
        addressLabel.textColor = currenTheme.mainTextColor
        addressContaine.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor.withAlphaComponent(0.4))
        networkContainer.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor.withAlphaComponent(0.4))
        amountContainer.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor.withAlphaComponent(0.4))
        baseContainer.backgroundColor = (currentTheme == .dark ? currenTheme.marginColor : UIColor.init(hex: "F9F9FE"))
        self.backBtn.tintColor = currenTheme.mainTextColor
        self.dropBtn.tintColor = currenTheme.mainTextColor
        self.withdrawBtn.tintColor = currenTheme.backgroundColor
        self.addressTitle.textColor = currenTheme.mainTextColor
        self.tokenBalance.textColor = currenTheme.mainTextColor
        self.totalAmount.textColor = currenTheme.mainTextColor
        self.networkTitle.textColor = currenTheme.mainTextColor
        self.amountField.textColor = currenTheme.mainTextColor
        self.amountTitle.textColor = currenTheme.mainTextColor
        self.withdrawTitle.textColor = currenTheme.mainTextColor
        self.networkField.textColor = currenTheme.mainTextColor
        self.maxTitle.textColor = currenTheme.mainTextColor
        self.withdrawBtn.backgroundColor = currenTheme.mainButtonColor
        self.withdrawBtn.disable()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func scanAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "QRScanner", bundle: nil).instantiateViewController(withIdentifier: "QRScannerViewController") as! QRScannerViewController
        vc.didScanQR = { address in
            self.addressLabel.text = address.components(separatedBy: "|").first
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func withdrawAction(_ sender: Any) {
        if let _ = UserDefaults.standard.value(forKey: "PIN") as? String {
            let vc = UIStoryboard.init(name: "SetupPin", bundle: nil).instantiateViewController(withIdentifier: "SetupPinViewController") as! SetupPinViewController
            vc.defaultMode = .verify
            vc.state = "V"
            vc.didSetPin = { code in
                let param: [String: Any] = [
                    "to": (self.addressLabel.text ?? ""),
                    "amount": self.totalAmount.text ?? "",
                    "asset_id": self.asset?.id ?? 0,
                    "network_id": self.network?.id ?? 0,
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
                            vc.isSendRecieve = false
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
        let param: [String: Any] = ["country_code":  UserDefaults.standard.string(forKey: "EXT") ?? "",
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
            "to": (self.addressLabel.text ?? ""),
            "amount": self.totalAmount.text ?? "",
            "asset_id": self.asset?.id ?? 0,
            "verification_id": verifID,
            "verification_code": pin,
            "network_id": self.network?.id ?? 0
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
                    vc.didClose = {
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
