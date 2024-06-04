//
//  ThemeTableViewCell.swift
//  EtherWallet
//
//  Created by Macbook Pro on 17/06/2022.
//

import UIKit

class ThemeTableViewCell: UITableViewCell {

    @IBOutlet weak var themeImage: UIImageView!
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var themeTiitle: UILabel!
    @IBOutlet weak var themeDesc: UILabel!
    
    var model: ThemeListModel? {
        didSet {
            themeTiitle.text = model?.title
            themeDesc.text = model?.desc
            themeDesc.isHidden = model?.desc == nil
            themeImage.image = UIImage.init(named: model?.image ?? "")
        }
    }
    
    func setup() {
        checkMark.rounded()
        
        container.addCornerRadius(16)
        
        let cTheme = ThemeManager.currentTheme(currentTheme)
        self.contentView.backgroundColor = cTheme.backgroundColor
        self.container.backgroundColor = cTheme.backgroundColor
        themeTiitle.textColor = cTheme.mainTextColor
        container.addBorder(cTheme.borderColor!)
        container.addBorder(cTheme.marginColor!)
        checkMark.image = UIImage.init(named: currentTheme == .dark ? "light-tick" : "tick")
    }
}
