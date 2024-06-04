//
//  ChooseCurrencyViewController.swift
//  Pebble
//
//  Created by macbookPro on 23/07/2022.
//

import UIKit

struct CountryCurrencyModel {
    var name: String
    var symbol: String
}

class ChooseCurrencyViewController: UIViewController {

    @IBOutlet weak var chooseTitle: UILabel!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var smoke: UIView!
    
    var index = 0 {
        didSet {
            self.tableView.reloadData()
        }
    }
//    CountryCurrencyModel.init(name: "Hong Kong Dollar", symbol: "HKD")
    var didSelectCurrency: ((CountryCurrencyModel) -> ())?
    
    let countries: [CountryCurrencyModel] = [CountryCurrencyModel.init(name: "UAE Dirham", symbol: "AED"), CountryCurrencyModel.init(name: "US Dollar", symbol: "USD"), CountryCurrencyModel.init(name: "Swiss Franc", symbol: "CHF"), CountryCurrencyModel.init(name: "Canadian Dollar", symbol: "CAD"), CountryCurrencyModel.init(name: "Australian Dollar", symbol: "AUD"), CountryCurrencyModel.init(name: "Euro", symbol: "EURO"), CountryCurrencyModel.init(name: "Chinese Yuan", symbol: "CNY")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        container.addCornerRadius(12)
        setupTableView()
        smoke.isUserInteractionEnabled = true
        smoke.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(closeView)))
    }
    
    @objc func closeView() {
        self.didSelectCurrency?(countries[index ?? 0])
        self.dismiss(animated: true)
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
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "ChooseCurrencyListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChooseCurrencyListTableViewCell")
        tableHeight.constant = CGFloat((countries.count*80)) > (self.view.frame.height - 150) ? (self.view.frame.height - 150) : CGFloat(countries.count*80)
    }
}

extension ChooseCurrencyViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCurrencyListTableViewCell") as! ChooseCurrencyListTableViewCell
        cell.model = self.countries[indexPath.row]
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
