//
//  RSSCollectionViewCell.swift
//  RSSFeed
//
//  Created by Tarang Hirani on 11/21/16.
//  Copyright © 2016 Tarang Hirani. All rights reserved.
//

import Foundation
import UIKit

class RSSCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func setUpCell(model: RSSModel) {
        self.titleLabel.text = model.title
    }
}
