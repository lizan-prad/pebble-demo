//
//  SettingsViewController.swift
//  Pebble
//
//  Created by macbookPro on 19/07/2022.
//

import UIKit
import Alamofire

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var vcTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var profile: ProfileModel? {
        didSet {
            tableView.reloadData()
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        self.fetchProfile()
        // Do any additional setup after loading the view.
    }
    
    func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
      
    }
    
    func fetchProfile() {
        self.showProgressHud()
        let url = "account/user"
        NetworkManager.shared.request(ProfileModel.self, urlExt: url, method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                self.profile = model
                UserDefaults.standard.set("Y", forKey: "PIN")
                UserDefaults.standard.set(model.mobile ?? "", forKey: "MOBILE")
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
                break
            }
        }
    }
    
    func setTheme() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currentTheme.backgroundColor
        self.tableView.backgroundColor = currentTheme.backgroundColor
        self.vcTitle.textColor = currentTheme.mainTextColor
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setTheme()
        self.tableView.reloadData()
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "AUTH")
        UserDefaults.standard.set(nil, forKey: "PIN")
        UserDefaults.standard.set(nil, forKey: "FACE")
        UserDefaults.standard.set(nil, forKey: "MOBILE")
        let coordinator = WelcomeCoordinator.init(navigationController: UINavigationController.init())
        appdelegate.window?.rootViewController = UINavigationController.init(rootViewController: coordinator.getMainView())
    }
    
    func sendVerification(_ code: String) {
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
                vc.hidesBottomBarWhenPushed = true
                vc.didGetPin = { pin in
                    self.setPin(code, pin, model.verificationId ?? "")
                }
                self.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
            }
        }
    }
    
    func setPin(_ code: String, _ pin: String, _ id: String) {
        self.showProgressHud()
        let url = "account/pincode"
        let param: [String: Any] = ["verification_id": id, "verification_code": pin, "pincode": code]
        NetworkManager.shared.request(RegisterModel.self, urlExt: url, method: .patch, param: param, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                
                self.tableView.reloadData()
                
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
            }
        }
    }

}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = UIStoryboard.init(name: "ChooseTheme", bundle: nil).instantiateViewController(withIdentifier: "ChooseThemeViewController") as! ChooseThemeViewController
            vc.didSetTheme = {
                
                self.setTheme()
                
                
                self.tableView.reloadData()
            }
            self.present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsThemeTableViewCell") as! SettingsThemeTableViewCell
            cell.setup()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsFaceIDTableViewCell") as! SettingsFaceIDTableViewCell
            cell.model = self.profile
            cell.setup()
            cell.didSetFace = {
                let vc = UIStoryboard.init(name: "SecurityFace", bundle: nil).instantiateViewController(withIdentifier: "SecurityFaceViewController") as! SecurityFaceViewController
                vc.isFromSettings = true
                self.present(vc, animated: true)
            }
            cell.didTapPhone = {
            }
            cell.didRemovePin = { code in
                self.sendVerification(code)
            }
            cell.didSetPIN = { state in
                let vc = UIStoryboard.init(name: "SetupPin", bundle: nil).instantiateViewController(withIdentifier: "SetupPinViewController") as! SetupPinViewController
                vc.defaultMode = state == "ADD" ? .set : .verify
                vc.state = state
                vc.didSetPin = { code in
                    self.sendVerification(code)
                }
                self.present(UINavigationController.init(rootViewController: vc), animated: true)
            }
            cell.didTapPassword  = {
                let vc = UIStoryboard.init(name: "ChangePassword", bundle: nil).instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsNotificationTableViewCell") as! SettingsNotificationTableViewCell
            cell.setup()
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsFAQTableViewCell") as! SettingsFAQTableViewCell
            cell.setup()
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 78
        case 1:
            return 200
        case 2:
            return 78
        case 3:
            return 130
        default:
            return 0
        }
    }
}
