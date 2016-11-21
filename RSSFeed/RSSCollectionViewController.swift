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
        
        
        cell.titleLabel.text = items[indexPath.row].title
        cell.linkLabel.text = items[indexPath.row].link
        cell.dateLabel.text = items[indexPath.row].pubdate
        cell.textView.text = items[indexPath.row].description
        cell.imageView.image = images[indexPath.row]
        
        
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
            //model.description
            
           
            
            
            if let startrange = self.content.range(of: ">&nbsp;"), let endRange = self.content.range(of: "<a href"){
                
                let substring = self.content[startrange.lowerBound...endRange.upperBound].stringByDecodingHTMLEntities
                
                    model.description = substring

            }
 
             if let startrange = self.content.range(of: "https://"), let endRange = self.content.range(of: ".jpg")
                {
             
                let substring = self.content[startrange.lowerBound...endRange.upperBound]
            
                    let url = URL(string: substring)
                    let data = try? Data(contentsOf: url!)
                    
                    images.append(UIImage(data: data!)!)
                    
                    
                }
            
            items.append(model)
            //print(items)
            //print(images)
            
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
            print(self.items[0])
        }
    }
    
    
    
}


// Mapping from XML/HTML character entity reference to character
// From http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references
private let characterEntities : [ String : Character ] = [
    // XML predefined entities:
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",
    
    // HTML character entity references:
    "&nbsp;"    : "\u{00a0}",
    // ...
    "&diams;"   : "♦",
]

extension String {
    
    /// Returns a new string made by replacing in the `String`
    /// all HTML character entity references with the corresponding
    /// character.
    var stringByDecodingHTMLEntities : String {
        
        // ===== Utility functions =====
        
        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(_ string : String, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }
        
        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(_ entity : String) -> Character? {
            
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X"){
                return decodeNumeric(entity.substring(with: entity.index(entity.startIndex, offsetBy: 3) ..< entity.index(entity.endIndex, offsetBy: -1)), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.substring(with: entity.index(entity.startIndex, offsetBy: 2) ..< entity.index(entity.endIndex, offsetBy: -1)), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        // ===== Method starts here =====
        
        var result = ""
        var position = startIndex
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self.range(of: "&", range: position ..< endIndex) {
            result.append(self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            if let semiRange = self.range(of: ";", range: position ..< endIndex) {
                let entity = self[position ..< semiRange.upperBound]
                position = semiRange.upperBound
                
                if let decoded = decode(entity) {
                    // Replace by decoded character:
                    result.append(decoded)
                } else {
                    // Invalid entity, copy verbatim:
                    result.append(entity)
                }
            } else {
                // No matching ';'.
                break
            }
        }
        // Copy remaining characters to `result`:
        result.append(self[position ..< endIndex])
        return result
    }
}
