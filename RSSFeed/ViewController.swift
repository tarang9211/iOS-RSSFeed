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
  private var session = URLSession(configuration: .default)
  private var items = [RSSModel]()
  
  //temporary fields
  private var articleTitle  = String()
  private var link          = String()
  private var pubdate       = String()
  private var content       = String()
  
  private var key = String()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.getRSSFeed()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  private func getRSSFeed() {
    let url = URL(string: "http://feeds.feedburner.com/TechCrunch/")!
    let urlRequest = URLRequest(url: url)
    
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
    
    self.key = elementName
    
    if (elementName.lowercased() == "item") {
      self.articleTitle = String()
      self.link = String()
      self.pubdate = String()
      self.content = String()
    }
  }
  
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    
    if (elementName.lowercased() == "item") {
      var model = RSSModel()
      model.title   = self.articleTitle
      model.link    = self.articleTitle
      model.pubdate = self.pubdate
      self.items.append(model)
    }
    
  }
  
  func parser(_ parser: XMLParser, foundCharacters string: String) {
    let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
    
    
    if (self.key == "title") {
      
      if (!(data.lowercased() == "techcrunch")) {
        self.articleTitle += data
      }
      
    }
      
    else if (self.key == "link") {
      self.link += data
    }
      
    else if (self.key == "pubdate") {
      self.pubdate += data
    }
  }
  
  func parserDidEndDocument(_ parser: XMLParser) {
    //reload table/collection view here
  }

}

