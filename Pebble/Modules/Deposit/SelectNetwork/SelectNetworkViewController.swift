//
//  SelectNetworkViewController.swift
//  Pebble
//
//  Created by macbookPro on 24/07/2022.
//

import UIKit
import Alamofire

struct ClinetNetworkModel {
    var client: String?
    var name: String?
    var logo: String?
}

var defaultClient: ClientType = .rinkeby

enum ClientType {
    case rinkeby
    case polygon
}

class SelectNetworkViewController: UIViewController {

    @IBOutlet weak var margin: UIView!
    @IBOutlet weak var chooseNetworkTitle: UILabel!
    @IBOutlet weak var smoke: UIView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var container: UIView!
    
    var didSetNetwork: ((Networks?) -> ())?
    
    var networks: [Networks]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setup()
        fetchNetworks()
        smoke.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismissPopUp)))
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "SelectNetworkTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectNetworkTableViewCell")
        self.tableViewHeight.constant = CGFloat((self.networks?.count ?? 0)*77)
    }
    
    @objc func dismissPopUp() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                    self.smoke.alpha = 0.0
                    
                }, completion: { _ in
                    self.dismiss(animated: true)
                })
        
    }
    
    func fetchNetworks() {
        self.showProgressHud()
        NetworkManager.shared.request(NetworkContainerModel.self, urlExt: "networks", method: .get, param: nil, encoding: URLEncoding.default, headers: HTTPHeaders.init()) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                break
//                self.networks = model.data
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.smoke.alpha = 0
        self.fogActivate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fogDeActivate()
    }

    func setup() {
        self.container.addCornerRadius(12)
//        connectBtn.addCornerRadius(10)
    }
    
    func fogActivate() {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveLinear, animations: {
                    self.smoke.alpha = 0.4
                    
                }, completion: { _ in
                    
                })
    }
    
    func fogDeActivate() {
        
    }
}

extension SelectNetworkViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectNetworkTableViewCell") as! SelectNetworkTableViewCell
        cell.model = networks?[indexPath.row]
        if let add = UserDefaults.standard.string(forKey: "DEFCL") {
            cell.checkMark.isHidden = !(networks?[indexPath.row].name == add)
            cell.container.addBorder(networks?[indexPath.row].name == add ? ColorConfig.baseColor : UIColor.init(hex: "9898A7"))
        } else {
            cell.checkMark.isHidden = indexPath.row != 0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(self.networks?[indexPath.row].name ?? "", forKey: "DEFCL")
        defaultClient = self.networks?[indexPath.row].name == "Polygon" ? .polygon : .rinkeby
        self.tableView.reloadData()
        self.didSetNetwork?(self.networks?[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
}
