//
//  HomePageViewController.swift
//  Pebble
//
//  Created by macbookPro on 19/07/2022.
//

import UIKit
import Alamofire
import SideMenu

class HomePageViewController: UIViewController {

    @IBOutlet weak var smoke: UIView!
    @IBOutlet weak var noTransactions: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var model: ProfileModel? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var balance: String? {
        didSet {
            
        }
    }
    var isOne = false
    var height: Int?
    
    var dates: [String]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var transactions: [[TransactionModel]]? {
        didSet {
            self.noTransactions.isHidden = transactions?.count != 0
            self.tableView.reloadData()
        }
    }
    let smokeV = UIView.init(frame: UIScreen.main.bounds)
    
    var txns = [TransactionModel]()
    
    let refreshControl = UIRefreshControl()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        smoke.isHidden = true
        smokeV.backgroundColor = .black
        smokeV.alpha = 0
        appdelegate.window?.rootViewController?.view.addSubview(smokeV)
        
        setup()
    }
    
    func setTheme() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currentTheme.backgroundColor
        self.tableView.backgroundColor = currentTheme.backgroundColor
        self.noTransactions.backgroundColor = currentTheme.backgroundColor
    }
    
    func fogActivate() {
        appdelegate.window?.rootViewController?.view.bringSubviewToFront(smokeV)
        self.smokeV.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveLinear, animations: {
            self.smokeV.alpha = 0.3
            
        }, completion: { _ in
            
        })
    }
    
    func dismissPopUp() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.smokeV.alpha = 0.0
            
        }, completion: { _ in
            self.smokeV.isHidden = true
           
        })
    }
    
    func setupSide() {
        let vc = UIStoryboard.init(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        vc.userName = self.model?.username
        vc.address = self.model?.public_address
        vc.didLoad = {
            self.fogActivate()
        }
        vc.didDismiss = {
            self.dismissPopUp()
        }
        let menu = SideMenuNavigationController(rootViewController: vc)
        menu.leftSide = true
        menu.sideMenuDelegate = self
        menu.presentationStyle = .menuSlideIn
        menu.menuWidth = self.view.frame.width - 50
        menu.pushStyle = .subMenu
        vc.didPush = { vc1 in
            menu.pushViewController(vc1, animated: true)
        }
        present(menu, animated: true, completion: nil)
    }
    
    func add() {
       
    }
    
    
    func fetchProfile() {
        self.showProgressHud()
        let url = "account/user"
        NetworkManager.shared.request(ProfileModel.self, urlExt: url, method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let model):
                
                self.model = model
                UserDefaults.standard.set((model.hasPin ?? true) ? "Y" : nil, forKey: "PIN")
                UserDefaults.standard.set(model.primaryAsset?.symbol ?? "", forKey: "PT")
                UserDefaults.standard.set(model.mobile ?? "", forKey: "MOBILE")
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
                break
            }
        }
    }
    
    func fetchTransactions(_ page: Int) {
        self.showProgressHud()
        let url = "account/crypto/transactions?page=\(page)"
        NetworkManager.shared.request(TransactionContainerModel.self, urlExt: url, method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let model):
                let m = model.data?.filter({$0.isInternal == 1})
                m?.forEach({ t in
                    self.txns.append(t)
                })
                if (model.data?.count != 0) && (model.data?.count ?? 0)%10 == 0 {
                   
                        self.fetchTransactions((self.txns.count/10) + 1)
                        return
                    
                }
                self.txns = self.txns.removeDuplicates()
                self.height = (self.txns.count)*70
                let arr = self.txns.map({[$0.txnDate ?? "": $0]})
                var result = [String : [TransactionModel]]()
                for dict in arr {
                    for (key, value) in dict {
                        result[key, default: []].append(value)
                    }
                }
                self.height = (self.height ?? 0) + (result.map({$0.key}).count*40)
                let r = result.sorted(by: { a, b in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let aKey = formatter.date(from: a.0) ?? Date()
                    let bKey = formatter.date(from: b.0) ?? Date()
                    return aKey > bKey
                })
                self.transactions = Array(r.map({ $0.value }))
                self.dates = Array(r.map({ $0.key }))
                break
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
                break
            }
        }
    }
    
    func fetchAssets() {
        self.showProgressHud()
        let url = "account/assets"
        NetworkManager.shared.requestArray(AssetModel.self, urlExt: url, method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let model):
                self.balance = "\(String(format: "%.4f", model.map({Double($0.balance ?? "") ?? 0}).reduce(0, +)))"
                break
//                self.model = model
            case .failure(let error):
                if self.isOne {
                    break
                } else {
                    self.isOne = true
                    self.fetchAssets()
                    
                }
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.txns = []
        setTheme()
        fetchTransactions(1)
        fetchAssets()
        fetchProfile()
        
    }
    
    func setup() {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib.init(nibName: "HomeTopTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTopTableViewCell")
        tableView.register(UINib.init(nibName: "TokenBalanceTableViewCell", bundle: nil), forCellReuseIdentifier: "TokenBalanceTableViewCell")
        tableView.register(UINib.init(nibName: "HomeHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeHeaderTableViewCell")
        tableView.register(UINib.init(nibName: "TransactionListHomeTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionListHomeTableViewCell")
       
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
          refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
          tableView.addSubview(refreshControl)
        
        self.view.isUserInteractionEnabled = true
        let swipe = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeOpen))
        swipe.direction = .right
        self.view.addGestureRecognizer(swipe)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.txns = []
        fetchProfile()
        fetchTransactions(1)
        fetchAssets()
    }
    
    @objc func swipeOpen() {
        self.setupSide()
    }
   
}

extension HomePageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTopTableViewCell") as! HomeTopTableViewCell
            cell.setup()
            cell.model = self.model
            cell.balance.text = self.balance ?? "0.0"
            cell.didTapNotif = {
                let vc = UIStoryboard.init(name: "Notification", bundle: nil).instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.didTap = {
                self.setupSide()
            }
            cell.didTapReceive = {
                let vc = UIStoryboard.init(name: "Receive", bundle: nil).instantiateViewController(withIdentifier: "ReceiveViewController") as! ReceiveViewController
                vc.hidesBottomBarWhenPushed = true
                vc.model = self.model
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.didTapSend = {
                let vc = UIStoryboard.init(name: "Send", bundle: nil).instantiateViewController(withIdentifier: "SendViewController") as! SendViewController
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TokenBalanceTableViewCell") as! TokenBalanceTableViewCell
            cell.setupCollection()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionListHomeTableViewCell") as! TransactionListHomeTableViewCell
            cell.setupTable()
            cell.h = height
//            cell.addPagination = { page in
//                self.fetchTransactions(page)
//            }
            cell.keys = self.dates
            cell.models = self.transactions
            cell.didSelectTxn = { txn in
                let vc = UIStoryboard.init(name: "TransactionReciept", bundle: nil).instantiateViewController(withIdentifier: "TransactionRecieptViewController") as! TransactionRecieptViewController
                vc.model = txn
                vc.isReciept = true
                vc.isSendRecieve = true
                vc.hidesBottomBarWhenPushed = true
                self.present(vc, animated: true, completion: nil)
            }
            return cell
        default: return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHeaderTableViewCell") as! HomeHeaderTableViewCell
            cell.setTheme()
            cell.didTapSee = {
                if section == 2 {
                    let vc = UIStoryboard.init(name: "TransactionList", bundle: nil).instantiateViewController(withIdentifier: "TransactionListViewController") as! TransactionListViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            cell.headerTitle.text = section == 1 ? "Token balance" : "Transactions"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0 || section == 1) ? 0 : 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0 :
            return UITableView.automaticDimension
        case 1:
            return 0
        case 2:
            return CGFloat(height ?? 0)
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
}

extension HomePageViewController: SideMenuNavigationControllerDelegate {
    
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        self.dismissPopUp()
    }
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}
