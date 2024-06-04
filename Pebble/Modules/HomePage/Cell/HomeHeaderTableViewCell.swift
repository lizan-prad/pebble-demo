//
//  HomeHeaderTableViewCell.swift
//  Pebble
//
//  Created by macbookPro on 19/07/2022.
//

import UIKit

class HomeHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var margin: UIView!
    @IBOutlet weak var seeBtn: UIButton!
    @IBOutlet weak var headerTitle: UILabel!
    
    var didTapSee: (() -> ())?
    
    @IBAction func seeAction(_ sender: Any) {
        self.didTapSee?()
    }
    
    func setTheme() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.contentView.backgroundColor = currentTheme.backgroundColor
        self.seeBtn.tintColor = currentTheme.mainTextColor
        self.headerTitle.textColor = currentTheme.mainTextColor
        self.margin.backgroundColor = currentTheme.marginColor
    }
}
