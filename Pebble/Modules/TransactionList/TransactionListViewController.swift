//
//  TransactionListViewController.swift
//  Pebble
//
//  Created by macbookPro on 01/08/2022.
//

import UIKit
import Alamofire

class TransactionListViewController: UIViewController {

    @IBOutlet weak var margin: UIView!
    @IBOutlet weak var noTransactions: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    let categories: [String] = ["All", "Sent", "Received"]
    
    var index = 0 {
        didSet {
            self.collectionView.reloadData()
            var fil = [TransactionModel]()
            
            switch categories[index] {
            case "Sent":
                fil = txns.filter({$0.type?.lowercased() == "withdraw"})
                let arr = fil.map({[$0.txnDate ?? "": $0]})
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
                self.filteredDates = Array(r.map({ $0.key }))
                self.filtered = Array(r.map({ $0.value }))
                
            case "Received":
                fil = txns.filter({$0.type?.lowercased() == "deposit"})
                let arr = fil.map({[$0.txnDate ?? "": $0]})
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
                self.filteredDates = Array(r.map({ $0.key }))
                self.filtered = Array(r.map({ $0.value }))
                
            default:
                self.txns = []
                self.fetchTransactions(1)
            }
        }
    }
    
    var filteredDates: [String]?
    
    var filtered: [[TransactionModel]]? {
        didSet {
            self.noTransactions.isHidden = transactions?.count != 0
            self.tableView.reloadData()
        }
    }
    
    var txns = [TransactionModel]()
    
    var dates: [String]? {
        didSet {
            filteredDates = dates
        }
    }
    var transactions: [[TransactionModel]]? {
        didSet {
            self.filtered = transactions
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        backBtn.setAttributedTitle(NSAttributedString.init(string: "Back", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 16)!]), for: .normal)
        setupTable()
        setupCollection()
    }
    
    func setupTable() {
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "TransactionListTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionListTableViewCell")
        tableView.register(UINib.init(nibName: "TransactionDateHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionDateHeaderTableViewCell")
        
    }
    
    func setTheme() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currentTheme.backgroundColor
        self.tableView.backgroundColor = currentTheme.backgroundColor
        self.noTransactions.backgroundColor = currentTheme.backgroundColor
        self.backBtn.tintColor = currentTheme.mainTextColor
        self.collectionView.backgroundColor = currentTheme.backgroundColor
        self.margin.backgroundColor = currentTheme.marginColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.txns = []
        fetchTransactions(1)
        self.setTheme()
    }
    
    func setupCollection() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib.init(nibName: "TransactionCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TransactionCategoryCollectionViewCell")
    }
    
    func fetchTransactions(_ page: Int) {
        self.showProgressHud()
        let url = "account/crypto/transactions?page=\(page)"
        NetworkManager.shared.request(TransactionContainerModel.self, urlExt: url, method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
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
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
                break
            }
        }
    }
    

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension TransactionListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredDates?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered?[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionListTableViewCell") as! TransactionListTableViewCell
        cell.setup()
        
        cell.model = self.filtered?[indexPath.section][indexPath.row]
//        if (indexPath.section + 1) >= (self.filteredDates?.count ?? 0) && (indexPath.row + 1) == (self.filtered?[(filteredDates?.count ?? 0) - 1].count) && ((filteredDates?.count ?? 0)%10) == 0 {
//            self.fetchTransactions(((filtered?.count ?? 0)/10) + 1)
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "TransactionReciept", bundle: nil).instantiateViewController(withIdentifier: "TransactionRecieptViewController") as! TransactionRecieptViewController
        vc.model = self.filtered?[indexPath.section][indexPath.row]
        vc.isReciept = true
        vc.isSendRecieve = true
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionDateHeaderTableViewCell") as! TransactionDateHeaderTableViewCell
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
        cell.setTheme()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension TransactionListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransactionCategoryCollectionViewCell", for: indexPath) as! TransactionCategoryCollectionViewCell
        cell.index = indexPath.row
        cell.categoryTitle.text = categories[indexPath.row]
        cell.setup()
        if cell.index == index {
            if currentTheme == .dark {
                cell.backgroundColor = .white
            } else {
                cell.backgroundColor = UIColor.init(hex: "D0D0D8")
            }
        } else {
            if currentTheme == .dark {
                cell.backgroundColor = UIColor.init(hex: "636573")
            } else {
                cell.backgroundColor = .white
            }
 
        }
        cell.contentView.addCornerRadius(12)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.index = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: ("\(self.categories[indexPath.row])".size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width) + 37, height: 36)
    }
}
