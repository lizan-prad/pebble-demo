//
//  SettingsFAQTableViewCell.swift
//  Pebble
//
//  Created by macbookPro on 12/08/2022.
//

import UIKit

class SettingsFAQTableViewCell: UITableViewCell {

    @IBOutlet weak var usefulContentLabel: UILabel!
    @IBOutlet weak var faqLabel: UILabel!
    
    
    func setup() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.contentView.backgroundColor = currentTheme.backgroundColor
        self.usefulContentLabel.textColor = currentTheme.mainTextColor
        self.faqLabel.textColor = currentTheme.mainTextColor
    }
}
