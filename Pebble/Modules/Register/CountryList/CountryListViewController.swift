//
//  CountryListViewController.swift
//  Pebble
//
//  Created by macbookPro on 02/08/2022.
//

import UIKit

class CountryListViewController: UIViewController {

    @IBOutlet weak var margin: UIView!
    @IBOutlet weak var chooseTitle: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var smoke: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchView: UIView!
    
    var countries: [CountryModel]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var didSelect: ((String) -> ())?
    var country: String?
    
    var selected: CountryModel? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        countries = CountryManager.shared.countries
        self.selected = countries?.filter({$0.countryCode == country}).first
        smoke.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismissPopUp)))
        
        searchView.addCornerRadius(16)
        searchField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
    }
    
    @objc func textChanged(_ sender: UITextField) {
        if sender.text == "" {
            countries = CountryManager.shared.countries
        } else {
            countries = CountryManager.shared.countries.filter({$0.name?.lowercased().contains(sender.text?.lowercased() ?? "") ?? false})
        }
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.container.backgroundColor = currenTheme.backgroundColor
        self.tableView.backgroundColor = currenTheme.backgroundColor
        chooseTitle.textColor = currenTheme.mainTextColor
        searchView.addBorder(currentTheme == .dark ? .white : ColorConfig.baseColor.withAlphaComponent(0.4))
        self.searchField.textColor = currenTheme.mainTextColor
        self.margin.backgroundColor = currenTheme.marginColor
    }
    
    func setup() {
        self.container.addCornerRadius(12)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib.init(nibName: "CountryListTableViewCell", bundle: nil), forCellReuseIdentifier: "CountryListTableViewCell")
    }

    @objc func dismissPopUp() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                    self.smoke.alpha = 0.0
                    
                }, completion: { _ in
                    
                    self.dismiss(animated: true)
                })
        
    }
    
    func getCountry(code: String) -> CountryModel? {
        return self.countries?.filter({$0.countryCode == code}).first
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.smoke.alpha = 0
        self.fogActivate()
        self.setTheme()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    
    func fogActivate() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveLinear, animations: {
                    self.smoke.alpha = 0.4
                    
                }, completion: { _ in
                    
                })
    }
}

extension CountryListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryListTableViewCell") as! CountryListTableViewCell
        cell.model = countries?[indexPath.row]
        cell.container.addBorder(cell.model?.countryCode != selected?.countryCode ? UIColor.init(hex: "9898A7") : ColorConfig.baseColor)
        cell.checkMark.isHidden = cell.model?.countryCode != selected?.countryCode
        cell.setTheme()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelect?(countries?[indexPath.row].countryCode ?? "")
        self.dismissPopUp()
//        self.selected = countries?[indexPath.row]
    }
}
