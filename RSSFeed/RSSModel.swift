//
//  RSSModel.swift
//  RSSFeed
//
//  Created by Tarang Hirani on 11/12/16.
//  Copyright © 2016 Tarang Hirani. All rights reserved.
//

import Foundation
import UIKit

class RSSModel {
    var title: String
    var link: String
    var pubdate: String //cast it to a Date later
    var description: String
    var imgUrl: String
    var image: UIImage?
    
    init(title: String, link: String, pubdate: String, description: String, imgUrl: String) {
        self.title = title
        self.link = link
        self.pubdate = pubdate
        self.description = description
        self.imgUrl = imgUrl
    }
}
