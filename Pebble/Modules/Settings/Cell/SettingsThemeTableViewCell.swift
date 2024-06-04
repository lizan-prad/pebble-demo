//
//  SettingsThemeTableViewCell.swift
//  Pebble
//
//  Created by macbookPro on 12/08/2022.
//

import UIKit

class SettingsThemeTableViewCell: UITableViewCell {

    @IBOutlet weak var margin: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    
    func setup() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.contentView.backgroundColor = currentTheme.backgroundColor
        self.mainLabel.textColor = currentTheme.mainTextColor
        margin.backgroundColor = currentTheme.marginColor
    }
}
