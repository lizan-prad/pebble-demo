//
//  BalanceTokenListTableViewCell.swift
//  Pebble
//
//  Created by macbookPro on 22/07/2022.
//

import UIKit
import SDWebImage
class BalanceTokenListTableViewCell: UITableViewCell {

    @IBOutlet weak var balanceStack: UIStackView!
    @IBOutlet weak var depositBtn: UIButton!
    @IBOutlet weak var currencyToken: UILabel!
    @IBOutlet weak var currencyAmount: UILabel!
    @IBOutlet weak var coinSYM: UILabel!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coimImage: UIImageView!
    @IBOutlet weak var container: UIView!
    
    var didDeposit: ((AssetModel?) -> ())?
    
    var model: AssetModel? {
        didSet {
            coinSYM.text = model?.symbol
            coinName.text = model?.name
            coimImage.sd_setImage(with: URL.init(string: model?.logo ?? ""))
        }
    }
    
    var balanceModel: [AssetModel]? {
        didSet {
            currencyAmount.text = "$" + (balanceModel?.filter({$0.symbol == model?.symbol}).first?.balance ?? "0.0")
            if (balanceModel?.filter({$0.symbol == model?.symbol}).first?.balance ?? "0.0") == "0.0" {
                depositBtn.isHidden = false
                self.balanceStack.isHidden = true
            } else {
                depositBtn.isHidden = true
                self.balanceStack.isHidden = false
            }
            currencyToken.text = (balanceModel?.filter({$0.symbol == model?.symbol}).first?.balance ?? "0.0") + " \(model?.symbol ?? "")"
        }
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.contentView.backgroundColor = currenTheme.backgroundColor
        self.container.backgroundColor = currentTheme == .dark ? currenTheme.marginColor : UIColor.init(hex: "F9F9FE")
        self.currencyAmount.textColor = currenTheme.mainTextColor
        self.coinName.textColor = currenTheme.mainTextColor
        self.depositBtn.backgroundColor = currenTheme.mainButtonColor
        self.depositBtn.tintColor = currenTheme.backgroundColor
    }
    
    func setup() {
        container.addCornerRadius(12)
        depositBtn.isHidden = true
        depositBtn.addCornerRadius(6)
        depositBtn.addTarget(self, action: #selector(depositAction), for: .touchUpInside)
        setTheme()
    }
    
    @objc func depositAction() {
        self.didDeposit?(self.model)
    }
}
