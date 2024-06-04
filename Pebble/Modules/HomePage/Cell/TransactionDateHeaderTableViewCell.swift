//
//  TransactionDateHeaderTableViewCell.swift
//  Pebble
//
//  Created by macbookPro on 11/08/2022.
//

import UIKit

class TransactionDateHeaderTableViewCell: UITableViewCell {

  
    @IBOutlet weak var dateLabel: UILabel!
    
    func setTheme() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.contentView.backgroundColor = currentTheme.backgroundColor
       
        self.dateLabel.textColor = currentTheme.mainTextColor
     
    }
}
