//
//  BaseTabbarViewController.swift
//  Pebble
//
//  Created by macbookPro on 17/07/2022.
//

import UIKit

class BaseTabbarViewController: UITabBarController, UITabBarControllerDelegate {

    var lineView: UIView!
    var back: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
//        tabBar.layer.shadowRadius = 1
//        tabBar.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
//        tabBar.layer.shadowOpacity = 0.4
        
        lineView = UIView(frame: CGRect(x: 0, y: -10, width:self.tabBar.frame.size.width, height: 1))
        lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        
        back = UIView(frame: CGRect(x: 0, y: -10, width:self.tabBar.frame.size.width, height: 100))
        back.backgroundColor = UIColor.init(hex: "636573").withAlphaComponent(0.2)
        self.tabBar.backgroundColor = UIColor.init(hex: "F1F1FA")
        self.tabBar.addSubview(back)
        self.tabBar.addSubview(lineView)
//        self.tabBar.tintColor = UIColor.init(hex: "F1F1FA")
//        self.setupMiddleButton()
//        self.viewControllers = []
        changeTheme()
//        let currentTheme = ThemeManager.currentTheme(currentTheme)
//        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: currentTheme.mainTextColor ?? UIColor.white, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height:  tabBar.frame.height), lineWidth: 2.0)
        
        self.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(changeTheme), name: Notification.Name.init(rawValue: "C-Theme"), object: nil)
        
    }
    
    @objc func changeTheme() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.tabBar.tintColor = currentTheme.mainButtonColor
        back.backgroundColor = currentTheme.backgroundColor
//        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: currentTheme.mainTextColor ?? UIColor.white, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height:  tabBar.frame.height - 30), lineWidth: 2.0)
        self.tabBar.backgroundColor = currentTheme.backgroundColor
    }
    
    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - 50
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        
        menuButton.backgroundColor = UIColor.red
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        
        view.addSubview(menuButton)
        
        menuButton.setImage(UIImage(named: "example"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        
        view.layoutIfNeeded()
    }
    
    @objc private func menuButtonAction(sender: UIButton) {
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

//        if let vc = (viewController as? UINavigationController)?.viewControllers.first as? WalletViewController {
//            let vc = UIStoryboard.init(name: "Send", bundle: nil).instantiateViewController(withIdentifier: "SendViewController") as! SendViewController
//    //        vc.account = self.account
//            vc.hidesBottomBarWhenPushed = true
//    //        vc.navigationItem.largeTitleDisplayMode = .always/
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        }

}
