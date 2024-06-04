//
//  NotificationDetailViewController.swift
//  Pebble
//
//  Created by macbookPro on 18/08/2022.
//

import UIKit
import Alamofire

class NotificationDetailViewController: UIViewController {

    @IBOutlet weak var notifDate: UILabel!
    @IBOutlet weak var notifMessage: UILabel!
    @IBOutlet weak var innerContainer: UIView!
    @IBOutlet weak var notifTitle: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var smoke: UIView!
    
    var model: NotificationModel?
    
    var didDismiss: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        self.readNotif()
        self.notifDate.text = model?.createdAt
        self.notifTitle.text = model?.data?.title
        self.notifMessage.text = model?.data?.message
        smoke.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismissPopUp)))
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.container.backgroundColor = currenTheme.backgroundColor
        self.notifTitle.textColor = currenTheme.mainTextColor
        innerContainer.backgroundColor = (currentTheme == .dark ? currenTheme.marginColor : UIColor.init(hex: "F9F9FE"))
    }
    
    func readNotif() {
        self.showProgressHud()
        let url = "account/notifications/\(model?.id ?? 0)/read"
        NetworkManager.shared.request(NotificationContainerModel.self, urlExt: url, method: .post, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(_):
                self.didDismiss?()
                break
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.smoke.alpha = 0
        self.fogActivate()
        self.setTheme()
    }
    
    func fogActivate() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveLinear, animations: {
                    self.smoke.alpha = 0.4
                    
                }, completion: { _ in
                    
                })
    }
    
    @objc func dismissPopUp() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                    self.smoke.alpha = 0.0
                    
                }, completion: { _ in
                    self.dismiss(animated: true)
                })
        
    }
    
    func setup() {
        container.addCornerRadius(8)
        innerContainer.addCornerRadius(16)
    }
    

}
