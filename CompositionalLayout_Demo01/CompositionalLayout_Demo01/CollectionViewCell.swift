//
//  CollectionViewCell.swift
//  CompositionalLayout_Demo01
//
//  Created by ankit bharti on 12/10/19.
//  Copyright © 2019 ankit kumar bharti. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var numberLabel: UILabel!

    func configure(by value: String) {
        self.numberLabel.text = value
    }
}
