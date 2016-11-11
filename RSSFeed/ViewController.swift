//
//  ViewController.swift
//  RSSFeed
//
//  Created by Tarang Hirani on 11/12/16.
//  Copyright © 2016 Tarang Hirani. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate {

  private var xmlParser: XMLParser!
  
  //temporary fields
  private var itemTitle: String!
  private var link: String!
  private var pubDate: String!
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
      DispatchQueue.main.async {
        self.xmlParser = XMLParser(data: data!) //pass data to the parser instance
        self.xmlParser.delegate = self
        self.xmlParser.parse()
        //should also be reloading the table/collection view here
      }
    }
    
    task.resume()
  }
  
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
    
    guard elementName.lowercased() == "item" else {
      return
    }
    
    //only elementNames with title will be printed. implementation might change later
    self.itemTitle = String()
    self.link = String()
    self.pubDate = String()
    
  }
  
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    
    guard elementName.lowercased() == "item" else {
      return
    }
    
  }
  
  func parser(_ parser: XMLParser, foundCharacters string: String) {
    
  }
  

}

