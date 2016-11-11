//
//  ViewController.swift
//  RSSFeed
//
//  Created by Tarang Hirani on 11/12/16.
//  Copyright © 2016 Tarang Hirani. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate {

  private var xmlParser = XMLParser()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.xmlParser.delegate = self
    self.getRSSFeed()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  private func getRSSFeed() {
    let url = URL(string: "https://www.cnet.com/rss/news/")!
    let urlRequest = URLRequest(url: url)
    let session = URLSession(configuration: .default)
    
    let task = session.dataTask(with: urlRequest) { (data, response, error) in
      self.xmlParser = XMLParser(data: data!) //pass data to the parser instance
      self.xmlParser.parse()
    }
    
    task.resume()
  }
  

}

