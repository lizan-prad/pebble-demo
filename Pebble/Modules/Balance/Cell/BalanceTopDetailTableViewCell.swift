//
//  BalanceTopDetailTableViewCell.swift
//  Pebble
//
//  Created by macbookPro on 05/08/2022.
//

import UIKit

class BalanceTopDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var primary: UILabel!
    @IBOutlet weak var balanceCurrency: UILabel!
    @IBOutlet weak var primaryTokenLabel: UILabel!
    @IBOutlet weak var currencyContainer: UIButton!
    @IBOutlet weak var chooseTokenContainer: UIView!
    
    var didSelectChooseToken: (() -> ())?
    var didSelectChooseCurrency: (() -> ())?
    
    func setup() {
        setTheme()
        currencyContainer.setAttributedTitle(NSAttributedString.init(string: "USD", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 12)!]), for: .normal)
        chooseTokenContainer.addCornerRadius(12)
        currencyContainer.addCornerRadius(8)
        chooseTokenContainer.isUserInteractionEnabled = true
        chooseTokenContainer.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(chooseToken)))
        currencyContainer.addTarget(self, action: #selector(openCurrency), for: .touchUpInside)
    }
    
    @objc func chooseToken() {
        self.didSelectChooseToken?()
    }
    
    func setTheme() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.mainView.backgroundColor = currentTheme.backgroundColor
        self.balanceCurrency.textColor = currentTheme.mainTextColor
        self.primary.textColor = currentTheme.mainTextColor
    }
    
    @objc func openCurrency() {
        self.didSelectChooseCurrency?()
    }
}
