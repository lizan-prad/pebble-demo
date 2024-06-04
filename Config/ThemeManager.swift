//
//  ThemeManager.swift
//  EtherWallet
//
//  Created by macbookPro on 16/06/2022.
//

import Foundation
import UIKit

struct Theme {
    var backgroundColor: UIColor?
    var mainButtonColor: UIColor?
    var mainTextColor: UIColor?
    var marginColor: UIColor?
    var borderColor: UIColor?
}

enum ThemeType {
    case dark
    case light
    case system
}

var currentTheme: ThemeType = .system

class ThemeManager {
    
    static func currentTheme(_ theme: ThemeType) -> Theme {
        switch theme {
        case .dark:
            return Theme.init(backgroundColor: ColorConfig.baseColor, mainButtonColor: .white, mainTextColor: .white, marginColor: UIColor.init(hex: "636573").withAlphaComponent(0.2), borderColor: UIColor.init(hex: "374151"))
        case .light:
            return Theme.init(backgroundColor: UIColor.init(hex: "F1F1FA"), mainButtonColor: ColorConfig.baseColor, mainTextColor: ColorConfig.baseColor, marginColor: UIColor.init(hex: "636573").withAlphaComponent(0.2), borderColor: UIColor.init(hex: "E5E7EB"))
        case .system:
            return Theme.init(backgroundColor: UIColor.init(hex: "F1F1FA"), mainButtonColor: ColorConfig.baseColor, mainTextColor: ColorConfig.baseColor, marginColor: UIColor.init(hex: "636573").withAlphaComponent(0.2), borderColor: UIColor.init(hex: "E5E7EB"))
        }
    }
    
    static func applyTheme(_ theme: Theme) {
        
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = ColorConfig.baseColor
        
        UINavigationBar.appearance().barTintColor = theme.backgroundColor
        UINavigationBar.appearance().backgroundColor = theme.backgroundColor
        
        
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")
        let attrs = [
            NSAttributedString.Key.foregroundColor: theme.mainTextColor,
            NSAttributedString.Key.font : UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 16)
        ]
        UIBarButtonItem.appearance().tintColor = theme.mainTextColor
        UIBarButtonItem.appearance().setTitleTextAttributes(attrs, for: .normal)
        UINavigationBar.appearance().titleTextAttributes = attrs
        UITabBar.appearance().tintColor = theme.mainTextColor
        
//        if #available(iOS 15.0, *) {
//            UITabBar.appearance().scrollEdgeAppearance?.backgroundColor = theme.backgroundColor
//        } else {
//            // Fallback on earlier versions
//        }
        UITabBar.appearance().backgroundColor = theme.backgroundColor
        UITabBar.appearance().barTintColor = theme.backgroundColor
    }
}
