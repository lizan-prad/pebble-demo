//
//  HomeTopTableViewCell.swift
//  Pebble
//
//  Created by macbookPro on 19/07/2022.
//

import UIKit
import SDWebImage

class HomeTopTableViewCell: UITableViewCell {

    @IBOutlet weak var bell: UIButton!
    @IBOutlet weak var picContainer: UIView!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var recieveBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var usdBtn: UIButton!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var initialP: UILabel!
    @IBOutlet weak var initialContainer: UIView!
    
    var model: ProfileModel? {
        didSet {
            profileImage.sd_setImage(with: URL.init(string: "https://cdn.plutopay.co/\(model?.avatar ?? "")"), placeholderImage: nil, options: .refreshCached, context: nil)
            profileName.text = model?.username
            self.initialP.text = model?.username?.prefix(1).uppercased()
        }
    }
    
    var didTapReceive: (() -> ())?
    var didTapSend: (() -> ())?
    
    var didTap: (() -> ())?
    var didTapNotif: (() -> ())?
    
    func setup() {
        profileImage.rounded()
        initialContainer.backgroundColor = getRandomAvatarColor()
        self.initialContainer.setStandardShadow()
        self.initialContainer.rounded()
        self.profileImage.rounded()
        self.picContainer.rounded()
        self.picContainer.addBorder(UIColor.init(hex: "9898A7").withAlphaComponent(0.1))
        self.recieveBtn.addCornerRadius(16)
        self.sendBtn.addCornerRadius(16)
        profileBtn.rounded()
        usdBtn.addCornerRadius(8)
        usdBtn.setAttributedTitle(NSAttributedString.init(string: "USD", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 12)!]), for: .normal)
        recieveBtn.setAttributedTitle(NSAttributedString.init(string: "Receive", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 16)!]), for: .normal)
        sendBtn.setAttributedTitle(NSAttributedString.init(string: "Send", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 16)!]), for: .normal)
        profileBtn.addTarget(self, action: #selector(didTapProfile), for: .touchUpInside)
        self.setTheme()
    }
    
    func setTheme() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        initialP.textColor = currentTheme.backgroundColor
        self.contentView.backgroundColor = currentTheme.backgroundColor
        self.bell.tintColor = currentTheme.mainTextColor
        self.profileName.textColor = currentTheme.mainTextColor
        self.balance.textColor = currentTheme.mainTextColor
    }
    
    @IBAction func notifAction(_ sender: Any) {
        self.didTapNotif?()
    }
    
    @objc func didTapProfile() {
        self.didTap?()
    }
    
    @IBAction func receiveAction(_ sender: Any) {
        self.didTapReceive?()
    }
    
    @IBAction func sendAction(_ sender: Any) {
        self.didTapSend?()
    }
}

func getRandomAvatarColor() -> UIColor {
    let colors:[String] = ["63D75A","E9C545","D75A9D","AF5AD7","5AAAD7","5AAAD7"]
    return UIColor.init(hex: colors.randomElement() ?? "")
}
