//
//  TransactionRecieptViewController.swift
//  Pebble
//
//  Created by macbookPro on 27/07/2022.
//

import UIKit
import Alamofire

class TransactionRecieptViewController: UIViewController {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UIButton!
    @IBOutlet weak var faqLabel: UIButton!
    @IBOutlet weak var confirmations: UILabel!
    @IBOutlet weak var confirmationStack: UIStackView!
    @IBOutlet weak var networkStack: UIStackView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var txnHash: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var tokenSymbol: UILabel!
    @IBOutlet weak var networkNamw: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var statusContainer: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var amountToken: UILabel!
    @IBOutlet weak var amountCurrency: UILabel!
    
    var model: TransactionModel?
    
    var isReciept = false
    var timer: Timer?
    var didClose: (() -> ())?
    var didLoad: (() -> ())?
    var isSendRecieve = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        if isSendRecieve {
            self.confirmationStack.isHidden = true
        } else {
            self.confirmationStack.isHidden = model?.status == "confirmed"
            self.confirmations.text = "\(model?.confirmations ?? 0)/\(model?.network?.min_confirmations ?? 0)"
        }
        self.backBtn.isHidden = isReciept
        self.closeBtn.isHidden = !isReciept
        self.didLoad?()
        networkStack.isHidden = isSendRecieve
        if isReciept {
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(fetchTxn), userInfo: nil, repeats: true)
        }
//        fetchNetworks()
    }
    
    @objc func fetchTxn() {
        self.fetchTransaction()
    }
    
    
    
    func fetchTransaction() {
        
//        self.showProgressHud()
        let url = "account/crypto/transactions/\(model?.id ?? 0)"
        NetworkManager.shared.request(TransactionModel.self, urlExt: url, method: .get, param: nil, encoding: URLEncoding.default, headers: nil) { result in
            self.hideProgressHud()
            switch result {
            case .success(let model):
                self.model = model
                if self.isSendRecieve {
                    self.confirmationStack.isHidden = true
                } else {
                    self.confirmationStack.isHidden = model.status == "confirmed"
                }
                self.confirmations.text = "\(model.confirmations ?? 0)/\(model.network?.min_confirmations ?? 0)"
                if model.status == "confirmed" {
                    self.confirmationStack.isHidden = true
                    self.timer?.invalidate()
                }
                self.setup()
            case .failure(let error):
                self.showToastMsg(error.localizedDescription, state: .error, location: .bottom)
                break
            }
        }
    }
    
    func setTheme() {
        let currenTheme = ThemeManager.currentTheme(currentTheme)
        self.view.backgroundColor = currenTheme.backgroundColor
        self.container.backgroundColor = currenTheme.backgroundColor
        self.backBtn.tintColor = currenTheme.mainTextColor
        if currentTheme == .dark {
            self.bottomContainer.backgroundColor = currenTheme.marginColor
        } else {
            self.bottomContainer.backgroundColor = UIColor.init(hex: "F9F9FE")
        }
        self.amountCurrency.textColor = currenTheme.mainTextColor
        self.dollarLabel.textColor = currenTheme.mainTextColor
        self.confirmations.textColor = currenTheme.mainTextColor
        self.tokenSymbol.textColor = currenTheme.mainTextColor
        self.networkNamw.textColor = currenTheme.mainTextColor
        self.txnHash.textColor = currenTheme.mainTextColor
        self.dateLabel.textColor = currenTheme.mainTextColor
        self.address.textColor = currenTheme.mainTextColor
        self.faqLabel.tintColor = currenTheme.mainTextColor
        self.arrivalLabel.tintColor = currenTheme.mainTextColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.setTheme()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer?.invalidate()
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
    
    func setup() {
        backBtn.setAttributedTitle(NSAttributedString.init(string: "Back", attributes: [.font: UIFont.init(name: "SatoshiVariable-Bold_Bold", size: 16)!]), for: .normal)
        address.text = ((model?.to == nil) || (model?.to == "")) ? (model?.to_user?.username ?? model?.to_user?.public_address) : model?.to
        txnHash.text = model?.tx_id ?? (model?.isInternal == 1 ? "Internal" : model?.tx_id)
        tokenSymbol.text = model?.asset?.symbol
        networkNamw.text = model?.network?.name
        status.text = model?.status
        statusContainer.rounded()
        if model?.status?.lowercased() == "confirmed" {
            statusImage.image = UIImage.init(named: "accept")
            statusContainer.backgroundColor = UIColor.init(hex: "4CC342")
        } else if model?.status?.lowercased() == "failed" {
            statusImage.image = UIImage.init(named: "reject")
            statusContainer.backgroundColor = UIColor.init(hex: "F21F1F")
        } else if model?.status?.lowercased() == "pending" {
            statusImage.image = UIImage.init(named: "pending")
            statusContainer.backgroundColor = UIColor.init(hex: "FFCF27")
        } else if model?.status?.lowercased() == "confirming" {
            statusImage.image = UIImage.init(named: "pending")
            statusContainer.backgroundColor = UIColor.init(hex: "FFCF27")
        }
        amountCurrency.text = model?.amount
        amountToken.text = "\(model?.amount ?? "") \(model?.asset?.symbol ?? "")"
        bottomContainer.addCornerRadius(16)
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
    }
    
    @objc func closeAction() {
        self.didClose?()
        self.dismiss(animated: true)
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
