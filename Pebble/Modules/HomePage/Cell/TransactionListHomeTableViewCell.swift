//
//  TransactionListHomeTableViewCell.swift
//  Pebble
//
//  Created by macbookPro on 11/08/2022.
//

import UIKit

class TransactionListHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var h: Int?
    var keys: [String]?
    var models: [[TransactionModel]]? {
        didSet {
            
            self.tableHeight.constant = CGFloat(h ?? 0)
            self.tableView.reloadData()
        }
    }
    
    var addPagination: ((Int) -> ())?
    
    var didSelectTxn: ((TransactionModel?) -> ())?
    
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
}

extension TransactionListHomeTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?[section].count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keys?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionListTableViewCell") as! TransactionListTableViewCell
        cell.setup()
        
        cell.model = self.models?[indexPath.section][indexPath.row]
        if (indexPath.section + 1) >= (self.keys?.count ?? 0) && (indexPath.row + 1) == self.models?[(keys?.count ?? 0) - 1].count && ((keys?.count ?? 0)%10) == 0 {
            self.addPagination?(((models?.count ?? 0)/10) + 1)
        }
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionDateHeaderTableViewCell") as! TransactionDateHeaderTableViewCell
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let sectionDate = formatter.date(from: keys?[section] ?? "")
        if keys?[section] == formatter.string(from: Date()) {
            cell.dateLabel.text = "Today"
        } else if formatter.string(from: sectionDate?.addingTimeInterval(-86400) ?? Date()) == formatter.string(from: Date().addingTimeInterval(-86400))  {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectTxn?(self.models?[indexPath.section][indexPath.row])
    }
}
