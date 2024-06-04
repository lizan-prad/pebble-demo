//
//  SettingsFaceIDTableViewCell.swift
//  Pebble
//
//  Created by macbookPro on 12/08/2022.
//

import UIKit

class SettingsFaceIDTableViewCell: UITableViewCell {

    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var pinLabel: UILabel!
    @IBOutlet weak var faceLabel: UILabel!
    @IBOutlet weak var pinSwitch: UISwitch!
    @IBOutlet weak var faceIdSwitch: UISwitch!
    @IBOutlet weak var phoneTitleLabel: UILabel!
    @IBOutlet weak var margin: UIView!
    
    
    var model: ProfileModel? {
        didSet {
            phoneLabel.text = "+\(model?.mobile?.prefix(5) ?? "")****\(model?.mobile?.suffix(2) ?? "")"
        }
    }
    var didRemovePin: ((String) -> ())?
    var didSetPIN: ((String) -> ())?
    var didSetFace: (() -> ())?
    var didTapPhone: (() -> ())?
    var didTapPassword: (() -> ())?
    
    func setup() {
        faceIdSwitch.isOn = UserDefaults.standard.string(forKey: "FACE") != nil
        pinSwitch.isOn = UserDefaults.standard.string(forKey: "PIN") != nil
        
        phoneLabel.isUserInteractionEnabled = true
        passwordLabel.isUserInteractionEnabled = true
        phoneLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(phoneAction)))
        passwordLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(passwordAction)))
        faceIdSwitch.addTarget(self, action: #selector(switchAction(_:)), for: .valueChanged)
        pinSwitch.addTarget(self, action: #selector(pinSwitchAction(_:)), for: .valueChanged)
        
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.contentView.backgroundColor = currentTheme.backgroundColor
        self.faceLabel.textColor = currentTheme.mainTextColor
        self.pinLabel.textColor = currentTheme.mainTextColor
        self.phoneTitleLabel.textColor = currentTheme.mainTextColor
        self.passwordLabel.textColor = currentTheme.mainTextColor
        margin.backgroundColor = currentTheme.marginColor
    }
    
    @objc func pinSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            self.didSetPIN?("ADD")
        } else {
            self.didRemovePin?("")
        }
    }
    
    @objc func switchAction(_ sender: UISwitch) {
        if sender.isOn {
            self.didSetFace?()
        } else {
            UserDefaults.standard.set(nil, forKey: "FACE")
        }
    }
    
    @objc func passwordAction() {
        self.didTapPassword?()
    }
    
    @objc func phoneAction() {
        self.didTapPhone?()
    }
}
