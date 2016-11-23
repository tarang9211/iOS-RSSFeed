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
        self.dateLabel.text = model.pubdate
        self.imageView.downloadImage(link: model.link)
        
        self.setUpCardCell()
        
    }
    
    private func setUpCardCell() {
        self.contentView.layer.backgroundColor = UIColor.white.cgColor
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.masksToBounds = true;
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width:0, height: 2.0)
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false;
    }
}
