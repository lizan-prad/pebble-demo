//
//  NumberCollectionViewCell.swift
//  EtherWallet
//
//  Created by Macbook Pro on 10/05/2022.
//

import UIKit

class NumberCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var numberlabel: UILabel!
    
    func setup() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        numberlabel.textColor = currentTheme.mainTextColor
        self.contentView.backgroundColor = currentTheme.backgroundColor
    }
}
