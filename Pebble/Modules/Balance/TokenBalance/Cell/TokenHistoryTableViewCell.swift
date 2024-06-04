//
//  TokenHistoryTableViewCell.swift
//  Pebble
//
//  Created by macbookPro on 22/07/2022.
//

import UIKit

class TokenHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var statusBg: UIImageView!
    @IBOutlet weak var currencyAmount: UILabel!
    @IBOutlet weak var transactionAmount: UILabel!
    @IBOutlet weak var transactionDate: UILabel!
    @IBOutlet weak var transactionType: UILabel!
    @IBOutlet weak var transactionImage: UIImageView!
    @IBOutlet weak var container: UIView!
    
    var model: TransactionModel? {
        didSet {
            transactionDate.textColor = UIColor.init(hex: "636573")
            transactionDate.text = model?.type == "withdraw" ? "Sent" : "Received"
            currencyAmount.text =  (model?.type?.lowercased() == "withdraw" ? "-" : "") + "$\(model?.amount ?? "")"
            transactionType.text = model?.type?.capitalized
            transactionImage.image = UIImage.init(named: "\(model?.type?.lowercased() ?? "")-status")
            transactionAmount.text = (model?.amount ?? "") + " \(model?.asset?.symbol ?? "")"
            if transactionDate.text == "Sent" {
                statusBg.isHidden = false
                transactionDate.text = model?.status?.lowercased() == "confirmed" ? "Sent" : (model?.status ?? "")
                
                if transactionDate.text != "Sent" {
                    transactionDate.textColor = model?.status?.lowercased() == "declined" ? UIColor.init(hex: "F21F1F") : UIColor.init(hex: "FFCF27")
                    statusBg.image = UIImage.init(named: model?.status?.lowercased() == "declined" ? "reject-bg" : "pending-bg")
                } else {
                    statusBg.image = UIImage.init(named: "success-bg")
                }
                if model?.isInternal == 1 {
                    transactionDate.text = "Sent to \(model?.to_user?.username ?? "")"
                }
            } else if transactionDate.text == "Received" {
                statusBg.isHidden = false
                transactionDate.text = model?.status?.lowercased() == "confirmed" ? "Received" : (model?.status ?? "")
                
                if transactionDate.text != "Received" {
                    transactionDate.textColor = model?.status?.lowercased() == "declined" ? UIColor.init(hex: "F21F1F") : UIColor.init(hex: "FFCF27")
                    statusBg.image = UIImage.init(named: model?.status?.lowercased() == "declined" ? "reject-bg" : "pending-bg")
                } else {
                    statusBg.image = UIImage.init(named: "success-bg")
                }
                if model?.isInternal == 1 {
                    transactionDate.text = "Received from \(model?.from_user?.username ?? "")"
                }
            } else {
                statusBg.isHidden = true
                transactionDate.textColor = UIColor.init(hex: "636573")
            }
        }
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        if currentTheme == .dark {
            transactionImage.image = UIImage.init(named: model?.type?.lowercased() == "withdraw" ? "\(model?.type?.lowercased() ?? "")-status-dark" : "\(model?.type?.lowercased() ?? "")-status-dark")
            self.container.backgroundColor = currenTheme.marginColor
        } else {
            transactionImage.image = UIImage.init(named: model?.type?.lowercased() == "withdraw" ? "\(model?.type?.lowercased() ?? "")-status" : "\(model?.type?.lowercased() ?? "")-status")
            self.container.backgroundColor = UIColor.init(hex: "F9F9FE")
        }
        self.contentView.backgroundColor = currenTheme.backgroundColor
        self.transactionType.textColor = currenTheme.mainTextColor
        self.currencyAmount.textColor = currenTheme.mainTextColor
    }
    
    
    func setup() {
        container.addCornerRadius(12)
    }
}
