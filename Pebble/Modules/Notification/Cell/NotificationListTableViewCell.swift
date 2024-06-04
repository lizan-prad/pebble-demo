//
//  NotificationListTableViewCell.swift
//  Pebble
//
//  Created by macbookPro on 12/08/2022.
//

import UIKit

class NotificationListTableViewCell: UITableViewCell {

    @IBOutlet weak var mailLogo: UIImageView!
    @IBOutlet weak var notifDate: UILabel!
    @IBOutlet weak var notifDesc: UILabel!
    @IBOutlet weak var notifTitle: UILabel!
    @IBOutlet weak var container: UIView!
    
    var model: NotificationModel? {
        didSet {
            self.mailLogo.image = UIImage.init(named: model?.readAt == nil ? "mail" : "notif-read")
            self.notifDate.text = model?.createdAt
            self.notifDesc.text = model?.data?.message
            self.notifTitle.text = model?.data?.title
        }
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.contentView.backgroundColor = currenTheme.backgroundColor
        self.container.backgroundColor = .clear
        if currentTheme == .dark {
            
            if model?.readAt == nil || model?.readAt == "" {
                mailLogo.tintColor = currenTheme.mainTextColor
                self.notifTitle.textColor = currenTheme.mainTextColor
                container.addBorder(currenTheme.mainTextColor!)
                notifDesc.textColor = UIColor.init(hex: "D0D0D8")
                notifDate.textColor = UIColor.init(hex: "D0D0D8")
            } else {
                mailLogo.tintColor = UIColor.init(hex: "636573")
                self.notifTitle.textColor = UIColor.init(hex: "636573")
                container.addBorder(UIColor.init(hex: "636573"))
                notifDesc.textColor = UIColor.init(hex: "636573")
                notifDate.textColor = UIColor.init(hex: "636573")
            }
        } else {
            container.addBorder(UIColor.init(hex: "D0D0D8"))
            if model?.readAt == nil || model?.readAt == "" {
                mailLogo.tintColor = currenTheme.mainTextColor
                self.notifTitle.textColor = currenTheme.mainTextColor
            } else {
                mailLogo.tintColor = UIColor.init(hex: "D0D0D8")
                self.notifTitle.textColor = UIColor.init(hex: "D0D0D8")
                notifDesc.textColor = UIColor.init(hex: "636573")
                notifDate.textColor = UIColor.init(hex: "636573")
            }
            
        }
        
       
    }
    
    func setup() {
        container.addCornerRadius(16)
        
        setTheme()
    }
}
