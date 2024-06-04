//
//  ChoosePrimaryTokenListTableViewCell.swift
//  Pebble
//
//  Created by macbookPro on 23/07/2022.
//

import UIKit
import SDWebImage

class ChoosePrimaryTokenListTableViewCell: UITableViewCell {

    @IBOutlet weak var tickMark: UIImageView!
    @IBOutlet weak var tokenSymbol: UILabel!
    @IBOutlet weak var tokenName: UILabel!
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var container: UIView!
    
    var model: AssetModel? {
        didSet {
            tokenName.text = model?.name
            tokenSymbol.text = "(\(model?.symbol ?? ""))"
            tokenImage.sd_setImage(with: URL.init(string: model?.logo ?? ""))
            container.addCornerRadius(16)
            
        }
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.contentView.backgroundColor = currenTheme.backgroundColor
        if currentTheme == .dark {
            tickMark.image = UIImage.init(named: "light-tick")
//            self.container.backgroundColor = currenTheme.marginColor
        } else {
            tickMark.image = UIImage.init(named: "tick")
//            self.container.backgroundColor = UIColor.init(hex: "F9F9FE")
        }
        container.addBorder(currenTheme.marginColor!)
//        self.container.backgroundColor = currenTheme.marginColor
        tokenName.textColor = currenTheme.mainTextColor
    }
}
