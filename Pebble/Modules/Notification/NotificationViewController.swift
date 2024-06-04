//
//  NotificationViewController.swift
//  Pebble
//
//  Created by macbookPro on 12/08/2022.
//

import UIKit
import Alamofire

class NotificationViewController: UIViewController {

    @IBOutlet weak var notif: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    
    var models: [NotificationModel]? {
        didSet {
            if models?.isEmpty ?? true {
                self.tableView.backgroundView = backView
            } else {
                self.tableView.backgroundView = nil
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.setAttributedTitle(NSAttributedString.init(string: "Back", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 16)!]), for: .normal)
        setupTable()
        
    }
    
    func setTheme() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currentTheme.backgroundColor
        self.tableView.backgroundColor = currentTheme.backgroundColor
        self.backBtn.tintColor = currentTheme.mainTextColor
        self.notif.textColor = currentTheme.mainTextColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTheme()
        fetchNotif()
    }
    
    func setupTable() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib.init(nibName: "NotificationListTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationListTableViewCell")
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchNotif() {
        self.showProgressHud()
        let url = "account/notifications"
        NetworkManager.shared.request(NotificationContainerModel.self, urlExt: url, method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                self.models = model.data
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
                break
            }
        }
    }

}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationListTableViewCell") as! NotificationListTableViewCell
        
        cell.model = models?[indexPath.row]
        cell.setup()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "NotificationDetail", bundle: nil).instantiateViewController(withIdentifier: "NotificationDetailViewController") as! NotificationDetailViewController
        vc.model = self.models?[indexPath.row]
        vc.didDismiss = {
            self.fetchNotif()
        }
        self.present(vc, animated: true)
    }
}
