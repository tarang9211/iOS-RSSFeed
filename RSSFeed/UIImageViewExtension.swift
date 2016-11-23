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
    
    func downloadImage(link: String, duration: Double = 0.25, callback: Image_Alias = { _ in }) {
        
        self.image = UIImage(named: "placeholder")
        
        let url =  URL(string: link)!
        let urlRequest = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            if (httpResponse.statusCode == 200) {
                if let imgData = data {
                    let img = UIImage(data: imgData)
                    
                    DispatchQueue.main.async {
                        self.image = img
                        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
                            self.image = img
                            }, completion: nil)
                    }
                }
            }
        }
        
        
        task.resume()
    }
}
