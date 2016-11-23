//
//  UIImageViewExtension.swift
//  RSSFeed
//
//  Created by Tarang Hirani on 11/23/16.
//  Copyright © 2016 Tarang Hirani. All rights reserved.
//

import Foundation
import UIKit

typealias Image_Alias = (UIImage) -> Void


extension UIImageView {
    
    func downloadImage(link: String) {
        
        let url =  URL(string: link)!
        let urlRequest = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
        }
        
        task.resume()
    }
}
