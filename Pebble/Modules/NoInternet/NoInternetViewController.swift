//
//  NoInternetViewController.swift
//  Pebble
//
//  Created by macbookPro on 17/08/2022.
//

import UIKit
import Alamofire
class NoInternetViewController: UIViewController {

    @IBOutlet weak var refreshBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        refreshBtn.addCornerRadius(16)
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        if NetworkReachabilityManager.default?.isReachable ?? false {
            self.dismiss(animated: true)
        } else {
            self.showToastMsg("No Internet Connection", state: .error, location: .bottom)
        }
    }
    

}
