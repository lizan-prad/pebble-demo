//
//  CountryListTableViewCell.swift
//  Pebble
//
//  Created by macbookPro on 02/08/2022.
//

import UIKit

class CountryListTableViewCell: UITableViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var countryPhone: UILabel!
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var countrySymbol: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryFlag: UIButton!
    
    var model: CountryModel? {
        didSet {
            checkMark.rounded()
            container.addCornerRadius(8)
            countryName.text = model?.name
            countryPhone.text = "+\(model?.phoneExtension ?? "")"
            countryFlag.rounded()
            countryFlag.setTitle(model?.flag ?? "", for: .normal)
        }
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.contentView.backgroundColor = currenTheme.backgroundColor
        if currentTheme == .dark {
            checkMark.image = UIImage.init(named: "light-tick")
//            self.container.backgroundColor = currenTheme.marginColor
        } else {
            checkMark.image = UIImage.init(named: "tick")
//            self.container.backgroundColor = UIColor.init(hex: "F9F9FE")
        }
        container.addBorder(currenTheme.marginColor!)
//        self.container.backgroundColor = currenTheme.marginColor
        countryName.textColor = currenTheme.mainTextColor
    }
}
