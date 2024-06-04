//
//  BackSpaceCollectionViewCell.swift
//  EtherWallet
//
//  Created by Macbook Pro on 10/05/2022.
//

import UIKit

class BackSpaceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backSpace: UIImageView!
    
    func setup() {
        backSpace.image = UIImage.init(named: currentTheme == .dark ? "backspcae-dark" : "backspace")
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.contentView.backgroundColor = currentTheme.backgroundColor
        
    }
}
