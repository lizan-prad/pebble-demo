//
//  TransactionListTableViewCell.swift
//  Pebble
//
//  Created by macbookPro on 20/07/2022.
//

import UIKit

class TransactionListTableViewCell: UITableViewCell {
    @IBOutlet weak var statusBg: UIImageView!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var amountCurrency: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tranTypeImage: UIImageView!
    
    @IBOutlet weak var container: UIView!
   
    var model: TransactionModel? {
        didSet {
            setupTheme()
            amount.text = "\(model?.amount ?? "") \(model?.asset?.symbol ?? "")"
            status.text = UserDefaults.standard.string(forKey: "MOBILE") == model?.to_user?.mobile ? "Received" : "Sent"
            if status.text == "Sent" {
                statusBg.isHidden = false
                status.text = model?.status?.lowercased() == "confirmed" ? "Sent" : (model?.status ?? "")
                if status.text != "Sent" {
                    status.textColor = model?.status?.lowercased() == "declined" ? UIColor.init(hex: "F21F1F") : UIColor.init(hex: "FFCF27")
                    statusBg.image = UIImage.init(named: model?.status?.lowercased() == "declined" ? "reject-bg" : "pending-bg")
                } else {
                    statusBg.image = UIImage.init(named: "success-bg")
            
                }
                
            } else {
                statusBg.isHidden = true
                status.textColor = UIColor.init(hex: "636573")
            }
            if status.text == "Received" {
                username.text = "\(model?.from_user?.username ?? "")"
            } else {
                username.text = "\(model?.to_user?.username ?? "")"
            }
            amountCurrency.text = (model?.type?.lowercased() == "withdraw" ? "-" : "") + "$\(model?.amount ?? "")"
        }
        
    }
    
    func setupTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        if currentTheme == .dark {
            tranTypeImage.image = UIImage.init(named: model?.type?.lowercased() == "withdraw" ? "send-tran" : "recieve-tran")
            self.container.backgroundColor = currenTheme.marginColor
        } else {
            tranTypeImage.image = UIImage.init(named: model?.type?.lowercased() == "withdraw" ? "send-tran" : "recieve-tran")
            self.container.backgroundColor = UIColor.init(hex: "F9F9FE")
        }
        self.contentView.backgroundColor = currenTheme.backgroundColor
        self.username.textColor = currenTheme.mainTextColor
        self.amountCurrency.textColor = currenTheme.mainTextColor
    }
    
    func setup() {
        container.addCornerRadius(12)
    }
    
}
