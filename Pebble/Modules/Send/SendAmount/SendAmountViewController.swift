//
//  SendAmountViewController.swift
//  Pebble
//
//  Created by macbookPro on 06/08/2022.
//

import UIKit
import Alamofire
import SDWebImage

class SendAmountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var initialP: UILabel!
    @IBOutlet weak var initialContainer: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var profileImageContainer: UIView!
    @IBOutlet weak var amountField: UITextField!
    
    var phone: String?
    var primary: AssetModel?
    var model: ProfileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.disable()
        setup()
        fetchProfile()
    }
    
    private func setup() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        profileImage.rounded()
        profileImage.sd_setImage(with: URL.init(string: "https://cdn.plutopay.co/\(model?.avatar ?? "")"), placeholderImage: nil, options: .refreshCached, context: nil)
        self.initialContainer.setStandardShadow()
        self.initialContainer.rounded()
        initialContainer.backgroundColor = getRandomAvatarColor()
        initialP.textColor = .white
        self.initialP.text = phone?.prefix(1).uppercased()
        self.usernameLabel.text = phone
        backBtn.setAttributedTitle(NSAttributedString.init(string: "Back", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 16)!]), for: .normal)
        nextBtn.addCornerRadius(16)
        profileImageContainer.rounded()
        amountField.font = UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 40)
        profileImageContainer.addBorder(UIColor.init(hex: "636573").withAlphaComponent(0.1))
        amountField.delegate = self
        amountField.addTarget(self, action: #selector(amountChanged(_:)), for: .editingChanged)
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currenTheme.backgroundColor
        usernameLabel.textColor = currenTheme.mainTextColor
        self.amountField.textColor = currentTheme == .dark ? UIColor.init(hex: "636573") : ColorConfig.baseColor
        self.backBtn.tintColor = currenTheme.mainTextColor
        self.nextBtn.tintColor = currenTheme.backgroundColor
        self.nextBtn.backgroundColor = currenTheme.mainButtonColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTheme()
    }
    
    @objc func amountChanged(_ sender: UITextField) {
        self.amountField.text = sender.text?.replacingOccurrences(of: ",", with: ".")
        if sender.text?.prefix(1) == "0" && sender.text?.count == 2 {
            if sender.text?.prefix(2) == "0." {
                self.nextBtn.disable()
            } else {
                self.amountField.text = ""
                self.nextBtn.disable()
            }
        } else if (sender.text == "." || sender.text == ",") && sender.text?.count == 1 {
            self.amountField.text = "0."
            self.nextBtn.disable()
        } else if Double(sender.text ?? "") != 0.0 && Double(sender.text ?? "") != 0 && Double(sender.text ?? "") != nil {
            if (Double(sender.text ?? "") ?? 0) < (Double(primary?.networks?.first?.min_withdraw_amount ?? "") ?? 0) {
                self.nextBtn.disable()
            } else {
                
                self.nextBtn.enable()
            }
        } else if (sender.text == "0.." || sender.text == "0.,") {
            self.amountField.text = "0."
            self.nextBtn.disable()
        } else {
            self.nextBtn.disable()
        }
        
    }
    
    func fetchProfile() {
        self.showProgressHud()
        let url = "assets"
        NetworkManager.shared.requestArray(AssetModel.self, urlExt: url, method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                self.primary = model.filter({UserDefaults.standard.string(forKey: "PT") == $0.symbol}).first
                
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
                break
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 8
    }

    @IBAction func nextAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "SendConfirmation", bundle: nil).instantiateViewController(withIdentifier: "SendConfirmationViewController") as! SendConfirmationViewController
        vc.phone = phone
//        vc.model = self.model
        vc.displayPhone = self.usernameLabel.text
        vc.amount = self.amountField.text
        vc.primary = self.primary
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
