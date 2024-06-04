//
//  TokenBalanceViewController.swift
//  Pebble
//
//  Created by macbookPro on 22/07/2022.
//

import UIKit
import Alamofire

class TokenBalanceViewController: UIViewController {

    @IBOutlet weak var margin: UIView!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var currencyAmount: UILabel!
    @IBOutlet weak var noTransactions: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var withdrawBtn: UIButton!
    @IBOutlet weak var depositBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedAsset: AssetModel?
    var mainAsset: AssetModel?
    
    var txns = [TransactionModel]()
    
    var dates: [String]?
    
    var transactions: [[TransactionModel]]? {
        didSet {
            self.noTransactions.isHidden = transactions?.count != 0
            self.tableView.reloadData()
        }
    }
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.txns = []
        self.setTheme()
        fetchAssets(true)
        fetchTransactions(1,true)
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            self.txns = []
            self.fetchAssets(false)
            self.fetchTransactions(1,false)
        }
    }
    
    func setup() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        withdrawBtn.addCornerRadius(16)
        depositBtn.addCornerRadius(16)
        backBtn.setAttributedTitle(NSAttributedString.init(string: "Back", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 16)!]), for: .normal)
        withdrawBtn.setAttributedTitle(NSAttributedString.init(string: "Withdraw", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 18)!]), for: .normal)
        depositBtn.setAttributedTitle(NSAttributedString.init(string: "Deposit", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 18)!]), for: .normal)
    }
    
    func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        tableView.register(UINib.init(nibName: "TokenHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "TokenHistoryTableViewCell")
        tableView.register(UINib.init(nibName: "TransactionDateHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionDateHeaderTableViewCell")
    }
    
    func setTheme() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currentTheme.backgroundColor
        self.tableView.backgroundColor = currentTheme.backgroundColor
        self.balanceLabel.textColor = currentTheme.mainTextColor
        self.backBtn.tintColor = currentTheme.mainTextColor
        self.depositBtn.tintColor = currentTheme.backgroundColor
        self.depositBtn.backgroundColor = currentTheme.mainButtonColor
        self.withdrawBtn.tintColor = currentTheme.backgroundColor
        self.withdrawBtn.backgroundColor = currentTheme.mainButtonColor
        self.noTransactions.backgroundColor = currentTheme.backgroundColor
        self.history.textColor = currentTheme.mainTextColor
        self.margin.backgroundColor = currentTheme.marginColor
    }
    
    func fetchAssets(_ showLoader: Bool) {
        if showLoader {
        self.showProgressHud()
        }
        let url = "account/assets"
        NetworkManager.shared.requestArray(AssetModel.self, urlExt: url, method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                self.balanceLabel.text = "\(model.filter({$0.id == self.selectedAsset?.id}).first?.balance ?? "0.00") \(self.selectedAsset?.symbol ?? "")"
                self.currencyAmount.text = "≈ $\(self.balanceLabel.text?.components(separatedBy: " ").first ?? "")"
                self.fetchAssetsMain(true)
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
            }
        }
    }
    
    func fetchAssetsMain(_ showLoader: Bool) {
        if showLoader {
        self.showProgressHud()
        }
        let url = "assets"
        NetworkManager.shared.requestArray(AssetModel.self, urlExt: url, method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                self.mainAsset = model.filter({$0.id == self.selectedAsset?.id}).first
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
            }
        }
    }
    
    @IBAction func withdrawAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Withdraw", bundle: nil).instantiateViewController(withIdentifier: "WithdrawViewController") as! WithdrawViewController
        vc.hidesBottomBarWhenPushed = true
        vc.asset = self.mainAsset
        vc.balance = self.balanceLabel.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchTransactions(_ page: Int, _ showLoader: Bool) {
        if showLoader {
//            self.showProgressHud()
        }
        let url = "account/crypto/transactions?page=\(page)"
        let param: [String: Any] = [
            "asset_id": self.selectedAsset?.id ?? 0
        ]
        NetworkManager.shared.request(TransactionContainerModel.self, urlExt: url, method: .get, param: param, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                let m = model.data
                m?.forEach({ t in
                    self.txns.append(t)
                })
                if self.txns.isEmpty && (model.data?.isEmpty ?? true) {
                    return
                }
                if (model.data?.count != 0) &&  self.txns.count%10 == 0 {
                    if (model.data?.count ?? 0)%10 == 0 {
                        self.fetchTransactions((self.txns.count/10) + 1, false)
                        return
                    }
                }
                let arr = self.txns.map({[$0.txnDate ?? "": $0]})
                var result = [String : [TransactionModel]]()
                for dict in arr {
                    for (key, value) in dict {
                        result[key, default: []].append(value)
                    }
                }
    
                let r = result.sorted(by: { a, b in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let aKey = formatter.date(from: a.0) ?? Date()
                    let bKey = formatter.date(from: b.0) ?? Date()
                    return aKey > bKey
                })
                self.dates = Array(r.map({ $0.key }))
                self.transactions = Array(r.map({ $0.value }))
                break
//                self.model = model
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
                break
            }
        }
    }
    
    @IBAction func depositAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Deposit", bundle: nil).instantiateViewController(withIdentifier: "DepositViewController") as! DepositViewController
        vc.hidesBottomBarWhenPushed = true
        vc.asset = self.selectedAsset
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TokenBalanceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dates?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TokenHistoryTableViewCell") as! TokenHistoryTableViewCell
        cell.setup()
        cell.model = self.transactions?[indexPath.section][indexPath.row]
        cell.setTheme()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "TransactionReciept", bundle: nil).instantiateViewController(withIdentifier: "TransactionRecieptViewController") as! TransactionRecieptViewController
        vc.model = self.transactions?[indexPath.section][indexPath.row]
        vc.isReciept = true
        vc.hidesBottomBarWhenPushed = true
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionDateHeaderTableViewCell") as! TransactionDateHeaderTableViewCell
        cell.setTheme()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let sectionDate = formatter.date(from: dates?[section] ?? "")
        if dates?[section] == formatter.string(from: Date()) {
            cell.dateLabel.text = "Today"
        } else if sectionDate?.addingTimeInterval(-86400) == Date().addingTimeInterval(-86400) {
            cell.dateLabel.text = "Yesterday"
        } else {
            formatter.dateFormat = "dd MMMM"
            cell.dateLabel.text = formatter.string(from: sectionDate ?? Date())
        }
        return cell
    }
}


