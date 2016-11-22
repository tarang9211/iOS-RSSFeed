//
//  RSSViewFlowLayout.swift
//  RSSFeed
//
//  Created by Aditya Yadav on 11/21/16.
//  Copyright © 2016 Tarang Hirani. All rights reserved.
//

import UIKit

class RSSViewFlowLayout: UICollectionViewFlowLayout {

    private var size = CGSize(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.5)
    
    override var itemSize: CGSize{
        get {
            return self.size
        }
        set{
            self.size = newValue
        }
    }
    
    
}
