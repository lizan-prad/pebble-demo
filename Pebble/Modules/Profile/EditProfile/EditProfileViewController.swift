//
//  EditProfileViewController.swift
//  Pebble
//
//  Created by macbookPro on 19/08/2022.
//

import UIKit
import Alamofire

class EditProfileViewController: UIViewController {

    @IBOutlet weak var usernameTitle: UILabel!
    @IBOutlet weak var fullnameTitle: UILabel!
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var initialP: UILabel!
    @IBOutlet weak var initialContainer: UIView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var availableStack: UIStackView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userNameContainer: UIView!
    @IBOutlet weak var nameContainer: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var userName: String?
    var fullName: String?
    var avatar: String?
    
    var didUpdate: (() -> ())?
    
    var selectedImage: UIImage? {
        didSet {
            self.profileImage.image = self.selectedImage
            self.uploadProfile()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        saveBtn.setAttributedTitle(NSAttributedString.init(string: "Save changes", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 18)!]), for: .normal)
        cancelBtn.setAttributedTitle(NSAttributedString.init(string: "Cancel", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 18)!]), for: .normal)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.profileImage.sd_setImage(with: URL.init(string: "https://cdn.plutopay.co/\(avatar ?? "")"))
        profileImage.rounded()
        saveBtn.addCornerRadius(16)
        self.imageContainer.rounded()
        self.imageContainer.addBorder(UIColor.init(hex: "9898A7").withAlphaComponent(0.1))
        self.initialContainer.setStandardShadow()
        self.initialContainer.rounded()
        self.initialP.text = userName?.prefix(1).uppercased()
        
        nameField.addTarget(self, action: #selector(namceChanged(_:)), for: .editingChanged)
       
        nameContainer.addCornerRadius(16)
        
        userNameField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        
        userNameContainer.addCornerRadius(16)
        userNameField.keyboardType = .alphabet
        self.nameField.text = fullName
        self.errorLabel.isHidden = !(fullName == nil || fullName == "")
        self.userNameField.text = userName
        self.availableStack.isHidden = true
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(uploadImage)))
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currenTheme.backgroundColor
        self.container.backgroundColor = currenTheme.backgroundColor
        userNameField.textColor = currenTheme.mainTextColor
        userNameContainer.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor.withAlphaComponent(0.4))
        nameField.textColor = currenTheme.mainTextColor
        nameContainer.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor.withAlphaComponent(0.4))
        self.cancelBtn.tintColor = currenTheme.mainTextColor
        self.saveBtn.tintColor = currenTheme.backgroundColor
        self.fullnameTitle.textColor = currenTheme.mainTextColor
        self.usernameTitle.textColor = currenTheme.mainTextColor
        self.saveBtn.backgroundColor = currenTheme.mainButtonColor
        saveBtn.disable()
    }
    
    @objc func uploadImage() {
        let imagePicker = ImagePickerManager()
        imagePicker.pickImage(self){ image in
            self.selectedImage = image
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.setTheme()
    }
    
    @objc func textChanged(_ sender: UITextField) {
        self.checkAvailability(sender.text ?? "")
    }
    
    @objc func namceChanged(_ sender: UITextField) {
       
            self.errorLabel.isHidden = (sender.text != "")
        
        self.validate()
    }
    
    func uploadProfile() {
        self.showProgressHud()
        let url = "account/avatar"
        NetworkManager.shared.requestMultipart(_value: LoginModel.self, param: [String:Any](), arrImage: [self.selectedImage ?? UIImage()], imageKey: "avatar", URlName: url, controller: self) { response in
            self.hideProgressHud()
            switch response {
            case .success(let model):
                self.showToastMsg("Profile image uploaded", state: .success, location: .bottom)
            case .failure(let error):
                self.profileImage.image = nil
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
                if self.userName == self.userNameField.text {
                    self.availableStack.isHidden = true
                } else {
                    self.availableStack.isHidden = false
                }
                self.validate()
                print(model.token)
            case .failure(let error):
                self.availableStack.isHidden = true
                self.validate()
                break
            }
        }
    }
    
    func updateUsername() {
        self.showProgressHud()
        let url = "account/user"
        let param: [String: Any] = ["username": self.userNameField.text ?? "", "name": nameField.text ?? ""]
        NetworkManager.shared.request(LoginModel.self, urlExt: url, method: .patch, param: param, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                UserDefaults.standard.set(self.userNameField.text ?? "", forKey: "USERNAME")
                self.showToastMsg("User updated!", state: .success, location: .bottom)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.dismiss(animated: true) {
                        self.didUpdate?()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
                break
            }
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        self.updateUsername()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func validate() {
        (nameField.text != "") && (userNameField.text == userName || (availableStack.isHidden == false ))  ? saveBtn.enable() : saveBtn.disable()
    }
}
