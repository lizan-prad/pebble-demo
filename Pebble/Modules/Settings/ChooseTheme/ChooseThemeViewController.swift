//
//  ChooseThemeViewController.swift
//  EtherWallet
//
//  Created by Macbook Pro on 17/06/2022.
//

import UIKit

struct ThemeListModel {
    var title: String?
    var desc: String?
    var image: String?
}



class ChooseThemeViewController: UIViewController {

    @IBOutlet weak var chooseTitle: UILabel!
    @IBOutlet weak var smoke: UIView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var container: UIView!
    
    var didSetTheme: (() -> ())?
    
    var themeList: [ThemeListModel] = [ThemeListModel.init(title: "System default", desc: "Once selected, the app will be set according to the system default", image: "system"), ThemeListModel.init(title: "Light", desc: nil, image: "light"), ThemeListModel.init(title: "Dark", desc: nil, image: "dark")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setup()
        
        smoke.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismissPopUp)))
        
    }
    
    @objc func dismissPopUp() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                    self.smoke.alpha = 0.0
                    
                }, completion: { _ in
                    self.dismiss(animated: true)
                })
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.smoke.alpha = 0
        self.fogActivate()
        setupTheme()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fogDeActivate()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "ThemeTableViewCell", bundle: nil), forCellReuseIdentifier: "ThemeTableViewCell")
        self.tableViewHeight.constant = CGFloat(self.themeList.count*90)
    }
    
    func setup() {
        self.container.addCornerRadius(30)
    }
    
    func fogActivate() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveLinear, animations: {
                    self.smoke.alpha = 0.4
                    
                }, completion: { _ in
                    
                })
    }
    
    func setupTheme() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        
        self.container.backgroundColor = currentTheme.backgroundColor
        self.tableView.backgroundColor = currentTheme.backgroundColor
        self.chooseTitle.textColor = currentTheme.mainTextColor
    }
    
    func fogDeActivate() {
        
    }
    

    @IBAction func addWalletAction(_ sender: Any) {
        
    }
    
    @IBAction func editWalletAction(_ sender: Any) {
    }

}

extension ChooseThemeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeTableViewCell") as! ThemeTableViewCell
        cell.model = themeList[indexPath.row]
        cell.setup()
        if let add = UserDefaults.standard.string(forKey: "Theme") {
            cell.checkMark.isHidden = !(themeList[indexPath.row].title == add)
            cell.container.addBorder(themeList[indexPath.row].title == add ? .white : UIColor.init(hex: "636573").withAlphaComponent(0.2))
            if currentTheme == .light {
                cell.container.addBorder(themeList[indexPath.row].title == add ? ColorConfig.baseColor.withAlphaComponent(0.6) : UIColor.init(hex: "636573").withAlphaComponent(0.2))
            }
        } else {
            cell.checkMark.isHidden = indexPath.row != 0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(self.themeList[indexPath.row].title ?? "", forKey: "Theme")
        self.tableView.reloadData()
        currentTheme = self.themeList[indexPath.row].title == "Dark" ? .dark : .light
//        UIApplication.shared.statusBarStyle = currentTheme == .dark ? .lightContent : .darkContent
        setupTheme()
        ThemeManager.applyTheme(ThemeManager.currentTheme(currentTheme))
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "C-Theme"), object: nil)
        self.didSetTheme?()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
