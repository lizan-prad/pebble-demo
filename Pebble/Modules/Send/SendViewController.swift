//
//  SendViewController.swift
//  Pebble
//
//  Created by macbookPro on 24/07/2022.
//

import UIKit

class SendViewController: UIViewController {

    @IBOutlet weak var howToSendTitle: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var usernameContainer: UIView!
    @IBOutlet weak var qrContainer: UIView!
    @IBOutlet weak var phoneContainer: UIView!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneBy: UILabel!
    @IBOutlet weak var phoneIcon: UIImageView!
    
    @IBOutlet weak var qrLabel: UILabel!
    @IBOutlet weak var qrBy: UILabel!
    @IBOutlet weak var scanIcon: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var atBy: UILabel!
    @IBOutlet weak var atIcon: UIImageView!
    
    var selectedType: String?
    var model: ProfileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.setSelectedView("phone")
    }
    
    func setup() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        backBtn.setAttributedTitle(NSAttributedString.init(string: "Back", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 16)!]), for: .normal)
//        phoneContainer.addBorder(ColorConfig.baseColor)
//        qrContainer.addBorder(currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7"))
//        usernameContainer.addBorder(currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7"))
        
        phoneContainer.addCornerRadius(8)
        qrContainer.addCornerRadius(8)
        usernameContainer.addCornerRadius(8)
        nextBtn.addCornerRadius(16)
        
        phoneContainer.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(phoneAction)))
        
        usernameContainer.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(usernameAction)))
        
        qrContainer.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(qrAction)))
    }
    
    func setTheme() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currentTheme.backgroundColor
        self.howToSendTitle.textColor = currentTheme.mainTextColor
        self.backBtn.tintColor = currentTheme.mainTextColor
        self.nextBtn.tintColor = currentTheme.backgroundColor
        self.nextBtn.backgroundColor = currentTheme.mainButtonColor
    }
    
    @objc func phoneAction() {
        self.setSelectedView("phone")
    }
    
    @objc func qrAction() {
        self.setSelectedView("qr")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTheme()
    }
    
    @objc func usernameAction() {
        self.setSelectedView("username")
    }
    
    func setSelectedView(_ type: String) {
        switch type {
        case "phone":
            phoneContainer.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor)
            qrContainer.addBorder(currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7"))
            usernameContainer.addBorder(currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7"))
            
            phoneIcon.tintColor = currentTheme == .dark ? .white : ColorConfig.baseColor
            phoneBy.textColor = currentTheme == .dark ? .white : ColorConfig.baseColor
            phoneLabel.textColor = currentTheme == .dark ? .white : ColorConfig.baseColor
            
            scanIcon.tintColor = currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7")
            qrBy.textColor = currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7")
            qrLabel.textColor = currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7")
            
            atIcon.tintColor = currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7")
            atBy.textColor = currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7")
            usernameLabel.textColor = currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7")
            self.selectedType = "phone"
        case "qr":
            qrContainer.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor)
            phoneContainer.addBorder(currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7"))
            usernameContainer.addBorder(currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7"))
            
            phoneIcon.tintColor = currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7")
            phoneBy.textColor = currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7")
            phoneLabel.textColor = currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7")
            
            scanIcon.tintColor = currentTheme == .dark ? .white : ColorConfig.baseColor
            qrBy.textColor = currentTheme == .dark ? .white : ColorConfig.baseColor
            qrLabel.textColor = currentTheme == .dark ? .white : ColorConfig.baseColor
            
            atIcon.tintColor = currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7")
            atBy.textColor = currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7")
            usernameLabel.textColor = currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7")
            self.selectedType = "qr"
        case "username":
            usernameContainer.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor)
            qrContainer.addBorder(currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7"))
            phoneContainer.addBorder(currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7"))
            
            phoneIcon.tintColor = currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7")
            phoneBy.textColor = currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7")
            phoneLabel.textColor = currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7")
            
            scanIcon.tintColor = currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7")
            qrBy.textColor = currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7")
            qrLabel.textColor = currentTheme == .dark ? UIColor.init(hex: "636573") : UIColor.init(hex: "9898A7")
            
            atIcon.tintColor = currentTheme == .dark ? .white : ColorConfig.baseColor
            atBy.textColor = currentTheme == .dark ? .white : ColorConfig.baseColor
            usernameLabel.textColor = currentTheme == .dark ? .white : ColorConfig.baseColor
            self.selectedType = "username"
        default: break
        }
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func nextAction(_ sender: Any) {
        switch selectedType ?? "" {
        case "phone":
            let vc = UIStoryboard.init(name: "SendWithPhone", bundle: nil).instantiateViewController(withIdentifier: "SendWithPhoneViewController") as! SendWithPhoneViewController
//            vc.model = self.model
            self.navigationController?.pushViewController(vc, animated: true)
        case "qr":
            let vc = UIStoryboard.init(name: "QRScanner", bundle: nil).instantiateViewController(withIdentifier: "QRScannerViewController") as! QRScannerViewController
            vc.didScanQR = { address in
                let vc = UIStoryboard.init(name: "SendAmount", bundle: nil).instantiateViewController(withIdentifier: "SendAmountViewController") as! SendAmountViewController
//                vc.model = self.model
                vc.phone = address.components(separatedBy: "|").last
                self.navigationController?.pushViewController(vc, animated: true)
            }
            self.present(vc, animated: true)
        case "username":
            let vc = UIStoryboard.init(name: "SendWithUsername", bundle: nil).instantiateViewController(withIdentifier: "SendWithUsernameViewController") as! SendWithUsernameViewController
//            vc.model = self.model
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
    }
    
}
