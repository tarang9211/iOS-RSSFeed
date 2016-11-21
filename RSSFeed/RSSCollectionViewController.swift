//
//  RSSCollectionViewController.swift
//  RSSFeed
//
//  Created by Tarang Hirani on 11/21/16.
//  Copyright © 2016 Tarang Hirani. All rights reserved.
//

import Foundation
import UIKit

class RSSCustomViewController: UICollectionViewController, XMLParserDelegate {
    private var xmlParser: XMLParser!
    private var session = URLSession(configuration: .default)
    private var items = [RSSModel]()
    private var images = [UIImage]()
    
    //temporary fields
    private var articleTitle  = String()
    private var link          = String()
    private var pubdate       = String()
    private var content       = String()
    private var key           = String()
    private var isItem        = false
    private var customCell    = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRSSFeed()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: CollectionViewController methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: customCell, for: indexPath) as! RSSCollectionViewCell
        cell.setUpCell(model: items[indexPath.row])
        return cell
    }
    
    
    // MARK: XML Parsing
    private func getRSSFeed() {
        let url = URL(string: "http://feeds.feedburner.com/TechCrunch/")!
        let urlRequest = URLRequest(url: url)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            self.xmlParser = XMLParser(data: data!) //pass data to the parser instance
            self.xmlParser.delegate = self
            self.xmlParser.parse()
        }
        
        task.resume()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        
        if (elementName == "item") {
            isItem = true
        }
        
        if (isItem) {
            switch elementName {
            case "title":
                self.articleTitle = String()
                self.key = "title"
                
            case "link":
                self.link = String()
                self.key = "link"
                
            case "pubDate":
                self.pubdate = String()
                self.key = "pubDate"
            
            case "description":
                self.content = String()
                self.key = "description"
                
            default:
                break
            }
            
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if (isItem) {
            switch self.key {
            case "title":
                self.key = String()
                
            case "link":
                self.key = String()
                
            case "pubDate":
                self.key = String()
            
            case "description":
                self.key = String()
                
            default:
                break
            }
        }
        
        if (elementName == "item") {
            var model = RSSModel()
            model.title = self.articleTitle
            model.link = self.link
            model.pubdate = self.pubdate
            items.append(model)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (isItem) {
            switch self.key {
            case "title":
                self.articleTitle += data
                
            case "link":
                self.link += data
                
            case "pubDate":
                self.pubdate += data
                
            case "description":
                self.content += data
                
            default:
                break
            }
        }
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    
    
}
