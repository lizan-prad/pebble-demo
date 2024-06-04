//
//  ChooseCurrencyListTableViewCell.swift
//  Pebble
//
//  Created by macbookPro on 23/07/2022.
//

import UIKit

class ChooseCurrencyListTableViewCell: UITableViewCell {

    @IBOutlet weak var tickMark: UIImageView!
    @IBOutlet weak var countrySymbol: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var container: UIView!
    
    var model: CountryCurrencyModel? {
        didSet {
            countryName.text = model?.name
            countrySymbol.text = "(\(model?.symbol ?? ""))"
            countryImage.image = UIImage.init(named: model?.symbol ?? "")
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
        countryName.textColor = currenTheme.mainTextColor
    }
}
