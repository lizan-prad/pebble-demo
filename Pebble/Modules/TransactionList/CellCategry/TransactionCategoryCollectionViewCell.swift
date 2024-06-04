//
//  TransactionCategoryCollectionViewCell.swift
//  Pebble
//
//  Created by macbookPro on 01/08/2022.
//

import UIKit

class TransactionCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryTitle: UILabel!
    
    var index: Int?
    
    func setup() {
        self.addCornerRadius(12)
    }
}
