//
//  BalanceViewController.swift
//  Pebble
//
//  Created by macbookPro on 19/07/2022.
//

import UIKit
import Alamofire

struct CoinModel {
    var name: String
    var symbol: String
    var image: String
}

class BalanceViewController: UIViewController {

   
    @IBOutlet weak var tableView: UITableView!
    
    var coins: [AssetModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var assets: [AssetModel]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var balance: String?
    var primaryToken: String? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var profile: ProfileModel? {
        didSet {
            self.primaryToken = profile?.primaryAsset?.symbol
        }
    }
    
    var selectedCurrency: CountryCurrencyModel? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setTheme()
            self.fetchProfile()
            self.fetchAssets()
            self.fetchAssetBalance()
        
    }
    
    func setTheme() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currentTheme.backgroundColor
        self.tableView.backgroundColor = currentTheme.backgroundColor
    }
    
    
    func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        tableView.register(UINib.init(nibName: "BalanceTokenListTableViewCell", bundle: nil), forCellReuseIdentifier: "BalanceTokenListTableViewCell")
        tableView.register(UINib.init(nibName: "HomeHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeHeaderTableViewCell")
        tableView.register(UINib.init(nibName: "BalanceTopDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "BalanceTopDetailTableViewCell")
        
    }
    
    
    func fetchAssets() {
        self.showProgressHud()
        NetworkManager.shared.requestArray(AssetModel.self, urlExt: "assets", method: .get, param: nil, encoding: URLEncoding.default, headers: HTTPHeaders.init()) { result in
            self.hideProgressHud()
            switch result {
            case .success(let models):
                self.coins = models
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
            }
        }
    }
    
    func fetchAssetBalance() {
        self.showProgressHud()
        NetworkManager.shared.requestArray(AssetModel.self, urlExt: "account/assets", method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let models):
                self.balance = "\(models.map({Double($0.balance ?? "") ?? 0}).reduce(0, +))"
                self.assets = models
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
            }
        }
    }
    
    func updatePrimaryToken(_ id: String) {
        self.showProgressHud()
        let url = "account/user"
        let param: [String: Any] = ["primary_asset_id": id]
        NetworkManager.shared.request(LoginModel.self, urlExt: url, method: .patch, param: param, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                break
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
            }
        }
    }
    
    func fetchProfile() {
        self.showProgressHud()
        let url = "account/user"
        NetworkManager.shared.request(ProfileModel.self, urlExt: url, method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                self.profile = model
                UserDefaults.standard.set(model.mobile ?? "", forKey: "MOBILE")
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
                break
            }
        }
    }
    
    

    func currencyAction() {
        let vc = UIStoryboard.init(name: "ChooseCurrency", bundle: nil).instantiateViewController(withIdentifier: "ChooseCurrencyViewController") as! ChooseCurrencyViewController
        vc.didSelectCurrency = { currency in
            self.selectedCurrency = currency
        }
        self.present(vc, animated: true)
    }
    
    @objc func chooseToken() {
        let vc = UIStoryboard.init(name: "ChoosePrimaryToken", bundle: nil).instantiateViewController(withIdentifier: "ChoosePrimaryTokenViewController") as! ChoosePrimaryTokenViewController
        vc.didSelectToken = { token in
            UserDefaults.standard.set(token?.id ?? 0, forKey: "PA")
            self.primaryToken = token?.symbol
            self.updatePrimaryToken("\(token?.id ?? 0)")
        }
        self.present(vc, animated: true)
    }
}

extension BalanceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : coins?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BalanceTopDetailTableViewCell") as! BalanceTopDetailTableViewCell
            cell.setup()
            cell.balanceCurrency.text = self.balance ?? "0.0"
            cell.currencyContainer.setTitle(selectedCurrency?.symbol ?? "", for: .normal)
            cell.primaryTokenLabel.text = primaryToken
            cell.didSelectChooseCurrency = {
                self.currencyAction()
            }
            
            cell.didSelectChooseToken = {
                self.chooseToken()
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "BalanceTokenListTableViewCell") as! BalanceTokenListTableViewCell
        cell.setup()
        cell.model = self.coins?[indexPath.row]
        cell.balanceModel = self.assets
        cell.didDeposit = { asset in
            let vc = UIStoryboard.init(name: "Deposit", bundle: nil).instantiateViewController(withIdentifier: "DepositViewController") as! DepositViewController
            vc.hidesBottomBarWhenPushed = true
            vc.asset = asset
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "TokenBalance", bundle: nil).instantiateViewController(withIdentifier: "TokenBalanceViewController") as! TokenBalanceViewController
        vc.hidesBottomBarWhenPushed = true
        vc.selectedAsset = self.coins?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 284 : 85
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHeaderTableViewCell") as! HomeHeaderTableViewCell
        cell.headerTitle.text = "Token balance"
        cell.seeBtn.isHidden = true
        cell.setTheme()
        return cell
    }
}


