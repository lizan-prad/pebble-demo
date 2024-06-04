//
//  TokenBalanceTableViewCell.swift
//  Pebble
//
//  Created by macbookPro on 20/07/2022.
//

import UIKit
import Alamofire

class TokenBalanceTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var tokens: [AssetModel]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
   
    func setupCollection() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = TagFlowLayout()
        layout.estimatedItemSize = CGSize(width: 140, height: 40)
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib.init(nibName: "TokenBalanceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TokenBalanceCollectionViewCell")
        self.fetchAssets()
    }
    
    func fetchAssets() {
        NetworkManager.shared.requestArray(AssetModel.self, urlExt: "assets", method: .get, param: nil, encoding: URLEncoding.default, headers: HTTPHeaders.init()) { result in
            switch result {
            case .success(let models):
                self.tokens = models
            case .failure(let error):
                
                break
            }
        }
    }
    
}

extension TokenBalanceTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tokens?.count ?? 0

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TokenBalanceCollectionViewCell", for: indexPath) as! TokenBalanceCollectionViewCell
        cell.tokenLabel.text = "\(self.tokens?[indexPath.row].symbol ?? ""): 64,295.38"
        cell.contentView.addCornerRadius(12)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: ("\(self.tokens?[indexPath.row].symbol ?? ""): 64,295.38".size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width) + 37, height: 40)
        
    }
}
