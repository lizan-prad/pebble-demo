//
//  SettingsNotificationTableViewCell.swift
//  Pebble
//
//  Created by macbookPro on 12/08/2022.
//

import UIKit

class SettingsNotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var margin: UIView!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationSwift: UISwitch!
    
    func setup() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
              if settings.authorizationStatus == .authorized {
                  DispatchQueue.main.async {
                      self.notificationSwift.isOn = true
                  }
              }
              else {
                  DispatchQueue.main.async {
                      self.notificationSwift.isOn = false
                  }
                  
              }
          }
        notificationSwift.addTarget(self, action: #selector(didChange(_:)), for: .valueChanged)
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.contentView.backgroundColor = currentTheme.backgroundColor
        self.notificationLabel.textColor = currentTheme.mainTextColor
        margin.backgroundColor = currentTheme.marginColor
    }
    
    @objc func didChange(_ sender: UISwitch) {
        if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings as URL, options: [:], completionHandler: nil)
        }
    }
}
