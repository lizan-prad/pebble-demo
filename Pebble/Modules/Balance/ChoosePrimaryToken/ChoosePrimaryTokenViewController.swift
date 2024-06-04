//
//  ChoosePrimaryTokenViewController.swift
//  Pebble
//
//  Created by macbookPro on 23/07/2022.
//

import UIKit
import Alamofire

struct TokenModel {
    var name: String
    var symbol: String
}

class ChoosePrimaryTokenViewController: UIViewController {
    
    @IBOutlet weak var chooseTitle: UILabel!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var smoke: UIView!
    
    var tokens: [AssetModel]? {
        didSet {
            tableHeight.constant = CGFloat(((tokens?.count ?? 0)*80)) > (self.view.frame.height - 80) ? (self.view.frame.height - 80) : CGFloat((tokens?.count ?? 0)*85)
            self.tableView.reloadData()
            tokens?.enumerated().forEach({ (index, e) in
                if  e.id == UserDefaults.standard.integer(forKey: "PA") {
                    self.index = index
                    return
                }
            })
        }
    }
    var didSelectToken: ((AssetModel?) -> ())?
    
    var index = 0 {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        container.addCornerRadius(12)
        setupTableView()
        self.fetchAssets()
        smoke.isUserInteractionEnabled = true
        smoke.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(closeView)))
        
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.container.backgroundColor = currenTheme.backgroundColor
        self.tableView.backgroundColor = currenTheme.backgroundColor
        chooseTitle.textColor = currenTheme.mainTextColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTheme()
    }
    
    @objc func closeView() {
        self.didSelectToken?(self.tokens?[index])
        self.dismiss(animated: true)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "ChoosePrimaryTokenListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChoosePrimaryTokenListTableViewCell")
        
    }
    
    func setupTheme() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        
    }
    
    func fetchAssets() {
        self.showProgressHud()
        NetworkManager.shared.requestArray(AssetModel.self, urlExt: "assets", method: .get, param: nil, encoding: URLEncoding.default, headers: HTTPHeaders.init()) { result in
            self.hideProgressHud()
            switch result {
            case .success(let models):
                self.tokens = models
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
            }
        }
    }

}

extension ChoosePrimaryTokenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tokens?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoosePrimaryTokenListTableViewCell") as! ChoosePrimaryTokenListTableViewCell
        cell.model = self.tokens?[indexPath.row]
        cell.tickMark.isHidden = index != indexPath.row
        cell.container.addBorder( index != indexPath.row ? UIColor.init(hex: "636573").withAlphaComponent(0.5) : UIColor.init(hex: "636573"))
        cell.setTheme()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        self.closeView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
