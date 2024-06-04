//
//  SelectNetworkTableViewCell.swift
//  EtherWallet
//
//  Created by Macbook Pro on 09/05/2022.
//

import UIKit

class SelectNetworkTableViewCell: UITableViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var networkName: UILabel!
    @IBOutlet weak var walletImage: UIImageView!
    
    
    var model: Networks? {
        didSet {
            checkMark.rounded()
            container.addCornerRadius(8)
            container.addBorder(UIColor.init(hex: "E5E7EB"))
            networkName.text = model?.name
            walletImage.image = UIImage.init(named: model?.name?.lowercased() ?? "")
        }
    }
    
}
