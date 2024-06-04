//
//  SetUserNameViewController.swift
//  Pebble
//
//  Created by macbookPro on 17/07/2022.
//

import UIKit
import Alamofire

class SetUserNameViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userNameContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameContainer.addBorder(ColorConfig.baseColor.withAlphaComponent(0.4))
        userNameContainer.addCornerRadius(16)
        confirmBtn.addCornerRadius(16)
        userNameField.keyboardType = .alphabet
        errorLabel.text = ""
        self.confirmBtn.disable()
        userNameField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    @objc func textChanged(_ sender: UITextField) {
        self.checkAvailability(sender.text ?? "")
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        self.updateUsername()
    }
    
    func updateUsername() {
        self.showProgressHud()
        let url = "account/user"
        let param: [String: Any] = ["username": self.userNameField.text ?? ""]
        NetworkManager.shared.request(LoginModel.self, urlExt: url, method: .patch, param: param, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                UserDefaults.standard.set(self.userNameField.text ?? "", forKey: "USERNAME")
                let vc = UIStoryboard.init(name: "BaseTabbar", bundle: nil).instantiateViewController(withIdentifier: "BaseTabbarViewController") as! BaseTabbarViewController
                appdelegate.window?.rootViewController = vc
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
                break
            }
        }
    }
    

    func checkAvailability(_ username: String) {
        self.showProgressHud()
        let url = "account/check-username"
        let param: [String: Any] = ["username": username]
        NetworkManager.shared.request(LoginModel.self, urlExt: url, method: .post, param: param, encoding: URLEncoding.default, headers: HTTPHeaders.init()) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                self.confirmBtn.enable()
                self.errorLabel.text = ""
                print(model.token)
            case .failure(let error):
                self.errorLabel.text = "Already Taken"
                self.confirmBtn.disable()
                break
            }
        }
    }
}
