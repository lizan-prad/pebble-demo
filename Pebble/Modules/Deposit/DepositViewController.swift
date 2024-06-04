//
//  DepositViewController.swift
//  Pebble
//
//  Created by macbookPro on 24/07/2022.
//

import UIKit
import Alamofire
import QRCode

class DepositViewController: UIViewController {

    @IBOutlet weak var drop: UIImageView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var scrollViewTop: NSLayoutConstraint!
    @IBOutlet weak var tokenTitleLabel: UILabel!
    @IBOutlet weak var depositLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var copyAddressBtn: UIButton!
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var networkContainer: UIView!
    
    var asset: AssetModel?
    var selectedNetwork: Networks? {
        didSet {
            UserDefaults.standard.set(self.selectedNetwork?.name ?? "", forKey: "DEFCL")
//            self.qrImage.image = selectedNetwork?.address?.generateQRCode()
//            self.addressLabel.text = selectedNetwork?.address
            self.networkLabel.text = selectedNetwork?.name
        }
    }
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchProfile()
        if hasTopNotch {
            self.scrollViewTop.constant = 80
        } else {
            self.scrollViewTop.constant = 40
        }
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.shareBtn.isHidden = true
        self.backBtn.isHidden = true
        self.depositLabel.text = "Deposit \(asset?.symbol ?? "")"
        self.tokenTitleLabel.text = "\(asset?.symbol ?? "") Deposit Address"
        self.selectedNetwork = asset?.networks?.first
        backBtn.setAttributedTitle(NSAttributedString.init(string: "Back", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 16)!]), for: .normal)
        shareBtn.setAttributedTitle(NSAttributedString.init(string: "Share QR", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 14)!]), for: .normal)
        
        networkContainer.addCornerRadius(8)
        doneBtn.addCornerRadius(16)
        networkContainer.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(selectAction)))
        shareBtn.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTheme()
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currenTheme.backgroundColor
        self.container.backgroundColor = currenTheme.backgroundColor
        depositLabel.textColor = currenTheme.mainTextColor
        networkContainer.addBorder(currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7"))
        self.backBtn.tintColor = currenTheme.mainTextColor
        self.doneBtn.tintColor = currenTheme.backgroundColor
        self.doneBtn.backgroundColor = currenTheme.mainTextColor
        self.drop.tintColor = currenTheme.backgroundColor
        self.networkLabel.textColor = currenTheme.mainTextColor
        self.addressLabel.textColor = currenTheme.mainTextColor
    }
    
    func fetchProfile() {
        self.showProgressHud()
        let url = "account/user"
        NetworkManager.shared.request(ProfileModel.self, urlExt: url, method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                self.addressLabel.text = model.public_address
                let design =  QRCode.Design.init(foregroundColor: currentTheme == .dark ? UIColor.white.cgColor : ColorConfig.baseColor.cgColor, backgroundColor: currentTheme == .dark ? ColorConfig.baseColor.cgColor : UIColor.init(hex: "F1F1FA").cgColor)
                design.shape.onPixels = QRCode.PixelShape.RoundedPath()
        
                self.qrImage.image = QRCode.init(text: "\(model.public_address ?? "")").uiImage(CGSize.init(width: 227, height: 227), scale: 12, design: design)
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
                break
            }
        }
    }
    
    @objc func shareImage() {
        //var messageStr:String  = "Check out my awesome iPicSafe photo!"
        let img: UIImage = self.qrImage.image ?? UIImage()
        //var shareItems:Array = [img, messageStr]
        let shareItems:Array = [img]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
       
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func copyAdressAction(_ sender: Any) {
        UIPasteboard.general.string = self.addressLabel.text
        self.showToastMsg("Address copied!", state: .success, location: .bottom)
    }
    
    @objc func selectAction() {
        let vc = UIStoryboard.init(name: "SelectNetwork", bundle: nil).instantiateViewController(withIdentifier: "SelectNetworkViewController") as! SelectNetworkViewController
        vc.networks = self.asset?.networks
        vc.didSetNetwork = { network in
            self.selectedNetwork = network
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
