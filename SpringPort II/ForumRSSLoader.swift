//
//  ForumRSSLoader.swift
//  SpringPort II
//
//  Created by MasterBel2 on 7/8/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Foundation

protocol ForumRSSLoading {
    func parse(_ rssURL: URL)
}

class ForumRSSLoader: ForumRSSLoading {
    //    1. Initialize a NSXMLParser object
    //    2. Specify the source URL and start parsing
    //    3. Use the NSXMLParser delegate methods to handle the parsed data
    
    let url = ""
    
    func parse(_ rssURL: URL) {
        let rssInterpreter = RSSInterpreter(didLoadChannel: didLoadChannel)
        
        guard let xmlParser = XMLParser(contentsOf: rssURL) else {
            fatalError("Could not construct XMLParser for url \(rssURL.absoluteString)")
        }
        xmlParser.delegate = rssInterpreter
        xmlParser.parse()
    }
    
    func didLoadChannel(_ channel: RSSChannel) -> () {
        print("Loaded Channel")
        print(channel.title)
    }
}

class RSSInterpreter: NSObject, XMLParserDelegate {
    let didLoadChannel: (RSSChannel) -> ()
    
    var elementStack: [XMLElement] = []
    var currentString: String = ""
    
    init(didLoadChannel: @escaping (RSSChannel) -> ()) {
        self.didLoadChannel = didLoadChannel
    }
    
    // MARK: XMLParserDelegate
    
    func parserDidStartDocument(_ parser: XMLParser) {
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        //        guard let channel = channel else { fatalError("No channel loaded from RSS feed") }
        //        didLoadChannel(channel)
        
        debugPrint("Parser completed parsing document.")
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        let element = XMLElement(key: elementName)
        elementStack.append(element)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentString = string
    }
    
    func parser(_ parser: XMLParser,didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard var element = elementStack.popLast() else { fatalError("Some error???") }
        element.value = currentString
        guard element.key == elementName else { fatalError("Element \(element.key) ended when not the last on the stack: expected \(elementName)") }
        currentString = ""
        
        if elementStack.count > 1 {
            let position = elementStack.count - 1
            elementStack[position].subElements.append(element)
        }
        
        if element.key == "channel" {
            if let rssChannel = channel(from: element) {
                didLoadChannel(rssChannel)
            }
        }
        
    }
    
    // MARK: Private Methods
    
    private func channel(from element: XMLElement) -> RSSChannel? {
        guard let descriptionElement = subElement(of: element, titled: "description"),
            let linkElement = subElement(of: element, titled: "link"),
            let titleElement = subElement(of: element, titled: "title") else { return nil }
        
        let channelItems: [RSSChannel.Item] = rssChannelItems(from: element)
        
        let image = rssImage(from: subElement(of: element, titled: "image"))
        
        let channel = RSSChannel(
            description: descriptionElement.value,
            link: linkElement.value,
            title: titleElement.value,
            items: channelItems,
            category: subElement(of: element, titled: "category")?.value,
            cloud: subElement(of: element, titled: "cloud")?.value,
            copyright: subElement(of: element, titled: "copyright")?.value,
            docs: subElement(of: element, titled: "docs")?.value,
            generator: subElement(of: element, titled: "generator")?.value,
            image: image,
            language: subElement(of: element, titled: "language")?.value,
            lastBuildDate: subElement(of: element, titled: "lastBuildDate")?.value,
            managingEditor: subElement(of: element, titled: "managingEditor")?.value,
            pubDate: subElement(of: element, titled: "pubDate")?.value,
            rating: subElement(of: element, titled: "rating")?.value,
            skipDays: subElement(of: element, titled: "skipDays")?.value,
            skipHours: subElement(of: element, titled: "skipHours")?.value,
            textInput: subElement(of: element, titled: "textInput")?.value,
            ttl: subElement(of: element, titled: "ttl")?.value,
            webmaster: subElement(of: element, titled: "webmaster")?.value)
        
        return channel
    }
    private func rssChannelItems(from xmlElement: XMLElement) -> [RSSChannel.Item] {
        let xmlChannelItems = subElements(of: xmlElement, titled: "item")
        var rssChannelItems: [RSSChannel.Item] = []
        for xmlChannelItem in xmlChannelItems {
            guard let channelItem = rssChannelItem(from: xmlChannelItem) else { break }
            rssChannelItems.append(channelItem)
        }
        return rssChannelItems
    }
    
    private func rssChannelItem(from element: XMLElement) -> RSSChannel.Item? {
        guard let description = subElement(of: element, titled: "description")?.value,
            let link = subElement(of: element, titled: "link")?.value,
            let title = subElement(of: element, titled: "title")?.value
            else { return nil }
        
        let enclosures: [RSSChannel.Item.Enclosure] = rssChannelItemEnclosures(from: element)
        
        let rssChannelItem = RSSChannel.Item(description: description,
                                             link: link,
                                             title: title,
                                             author: subElement(of: element, titled: "author")?.value,
                                             category: subElement(of: element, titled: "category")?.value,
                                             comments: subElement(of: element, titled: "comments")?.value,
                                             enclosures: enclosures,
                                             guid: subElement(of: element, titled: "guid")?.value,
                                             pubDate: subElement(of: element, titled: "pubDate")?.value,
                                             source: subElement(of: element, titled: "source")?.value)
        
        return rssChannelItem
    }
    
    private func rssChannelItemEnclosures(from element: XMLElement) -> [RSSChannel.Item.Enclosure] {
        let xmlChannelItemEnclosures = subElements(of: element, titled: "enclosure")
        var rssChannelItemEnclosures: [RSSChannel.Item.Enclosure] = []
        for xmlChannelItemEnclosure in xmlChannelItemEnclosures {
            guard let channelItemEnclosure = rssChannelItemEnclosure(from: xmlChannelItemEnclosure) else { break }
            rssChannelItemEnclosures.append(channelItemEnclosure)
        }
        return rssChannelItemEnclosures
    }
    
    private func rssChannelItemEnclosure(from element: XMLElement) -> RSSChannel.Item.Enclosure? {
        guard let length = subElement(of: element, titled: "length")?.value,
            let type = subElement(of: element, titled: "type")?.value,
            let url = subElement(of: element, titled: "url")?.value
            else { return nil }
        
        return nil
    }
    
    private func subElement(of element: XMLElement, titled title: String) -> XMLElement? {
        //        return (element.subElements.filter { $0.key == title })[0]
        return subElements(of: element, titled: title).first
    }
    
    private func subElements(of element: XMLElement, titled title: String) -> [XMLElement] {
        return element.subElements.filter { $0.key == title }
    }
    
    private func rssImage(from xmlElement: XMLElement?) -> RSSChannel.Image? {
        guard let element = xmlElement,
            let link = subElement(of: element, titled: "link")?.value,
            let title = subElement(of: element, titled: "title")?.value,
            let url = subElement(of: element, titled: "url")?.value
            else { return nil }
        
        let image = RSSChannel.Image(link: link, title: title, url: url)
        return image
    }
}

struct XMLElement {
    let key: String
    var value: String = ""
    var subElements: [XMLElement] = []
    
    init(key: String) {
        self.key = key
    }
}
