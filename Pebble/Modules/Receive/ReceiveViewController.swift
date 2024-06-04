//
//  ReceiveViewController.swift
//  Pebble
//
//  Created by macbookPro on 07/08/2022.
//

import UIKit
import QRCode

class ReceiveViewController: UIViewController {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var receive: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var copyNumber: UIButton!
    @IBOutlet weak var copyUsername: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var qrView: UIImageView!
    @IBOutlet weak var detailContainer: UIView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    var model: ProfileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        doneBtn.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
    }
    
    @objc func doneAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTheme()
    }
    

    func setup() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        shareBtn.isHidden = true
        self.username.text = model?.username
        self.phone.text = model?.mobile
        self.backBtn.isHidden = true
        detailContainer.addCornerRadius(16)
        
        
        doneBtn.addCornerRadius(16)
        backBtn.setAttributedTitle(NSAttributedString.init(string: "Back", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 16)!]), for: .normal)
        shareBtn.setAttributedTitle(NSAttributedString.init(string: "Share QR", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 14)!]), for: .normal)
        shareBtn.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currenTheme.backgroundColor
        self.container.backgroundColor = currenTheme.backgroundColor
        self.receive.textColor = currenTheme.mainTextColor
        self.shareBtn.tintColor = currenTheme.mainTextColor
        self.doneBtn.backgroundColor = currenTheme.mainButtonColor
        self.doneBtn.tintColor = currenTheme.backgroundColor
        self.backBtn.tintColor = currenTheme.mainTextColor
        detailContainer.addBorder(currenTheme.marginColor!)
        username.textColor = currenTheme.mainTextColor
        phone.textColor = currenTheme.mainTextColor
        let design =  QRCode.Design.init(foregroundColor: currenTheme.mainTextColor!.cgColor, backgroundColor: currenTheme.backgroundColor!.cgColor)
        design.shape.onPixels = QRCode.PixelShape.RoundedPath()

        self.qrView.image = QRCode.init(text: "Pay|\(self.model?.username ?? "")").uiImage(CGSize.init(width: 227, height: 227), scale: 12, design: design)
        let center = UIImage.init(named: currentTheme == .dark ? "qr-logo-dark" : "qr-logo")
        center?.addToCenter(of: self.qrView, width: 90, height: 90)
    }
    
    @objc func shareImage() {
        //var messageStr:String  = "Check out my awesome iPicSafe photo!"
        let img: UIImage = self.qrView.takeScreenshot()
        //var shareItems:Array = [img, messageStr]
        let shareItems:Array = [img]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
       
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func copyPhone(_ sender: Any) {
        UIPasteboard.general.string = self.phone.text
        self.showToastMsg("Phone number copied!", state: .success, location: .bottom)
    }
    
    @IBAction func copyUser(_ sender: Any) {
        UIPasteboard.general.string = self.username.text
        self.showToastMsg("Username copied!", state: .success, location: .bottom)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
