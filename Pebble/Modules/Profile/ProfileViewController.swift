//
//  ProfileViewController.swift
//  Pebble
//
//  Created by macbookPro on 23/07/2022.
//

import UIKit
import Alamofire
import SDWebImage
import QRCode

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var initialP: UILabel!
    @IBOutlet weak var initialContainer: UIView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var fullName: UILabel!
    
    var userName: String?
    var address: String?
    
    var didPush: ((EditProfileViewController) -> ())?
    
    var model: ProfileModel? {
        didSet {
            
            self.profileImage.sd_setImage(with: URL.init(string: "https://cdn.plutopay.co/\(model?.avatar ?? "")"), placeholderImage: nil, options: .refreshCached, context: nil)
            self.fullName.isHidden = (model?.name == nil || model?.name == "")
            self.fullName.text = model?.name
            userNameLabel.text = model?.username
            self.setQRTheme(model?.username ?? "")
            self.didLoad?()
        }
    }
    
    var didLoad: (() -> ())?
    
    var didDismiss: (() ->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage.rounded()
        shareBtn.isHidden = true
        fullName.isHidden = true
        editBtn.setAttributedTitle(NSAttributedString.init(string: "Edit", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Medium", size: 12)!]), for: .normal)
        editBtn.rounded()
        self.imageContainer.rounded()
        self.imageContainer.addBorder(UIColor.init(hex: "9898A7").withAlphaComponent(0.1))
        self.initialContainer.setStandardShadow()
        self.initialContainer.rounded()
        initialContainer.backgroundColor = getRandomAvatarColor()
        self.initialP.text = userName?.prefix(1).uppercased()
        shareBtn.setAttributedTitle(NSAttributedString.init(string: "Share QR", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 14)!]), for: .normal)
        // Do any additional setup after loading the view.
        shareBtn.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
    }
    
    func setTheme() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currentTheme.backgroundColor
        self.userNameLabel.textColor = currentTheme.mainTextColor
        initialP.textColor = currentTheme.backgroundColor
        self.shareBtn.tintColor = currentTheme.mainTextColor
        self.fullName.textColor = currentTheme.mainTextColor
    }
    
    func setQRTheme(_ username: String) {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        let design =  QRCode.Design.init(foregroundColor: currenTheme.mainTextColor!.cgColor, backgroundColor: currenTheme.backgroundColor!.cgColor)
        design.shape.onPixels = QRCode.PixelShape.RoundedPath()

        self.qrImage.image = QRCode.init(text: "Pay|\(username)").uiImage(CGSize.init(width: 227, height: 227), scale: 12, design: design)
        let center = UIImage.init(named: currentTheme == .dark ? "qr-logo-dark" : "qr-logo")
        center?.addToCenter(of: self.qrImage, width: 90, height: 90)
    }
    
    @IBAction func editAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "EditProfile", bundle: nil).instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        vc.userName = self.userNameLabel.text
        vc.fullName = self.model?.name
        vc.avatar = self.model?.avatar
        vc.didUpdate = {
            self.fetchProfile()
        }
        vc.hidesBottomBarWhenPushed = true
        self.didPush?(vc)
    }
    
    func fetchProfile() {
        self.showProgressHud()
        let url = "account/user"
        NetworkManager.shared.request(ProfileModel.self, urlExt: url, method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                self.model = model
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
                break
            }
        }
    }
    
    @objc func shareImage() {
        //var messageStr:String  = "Check out my awesome iPicSafe photo!"
        let img: UIImage = self.qrImage.takeScreenshot()
        //var shareItems:Array = [img, messageStr]
        let shareItems:Array = [img]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
       
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.setTheme()
        self.fetchProfile()
        
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.didDismiss?()
        }
    }
    

}
