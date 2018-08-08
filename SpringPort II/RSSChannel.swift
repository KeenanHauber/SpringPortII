//
//  RSSChannel.swift
//  SpringPort II
//
//  Created by Derek Bel on 8/8/18.
//  Copyright © 2018 MasterBel2. All rights reserved.
//

import Foundation

struct RSSChannel { // Documentation credit: https://www.w3schools.com/xml/xml_rss.asp
    
    // MARK: Stored Properties
    
    // Required
    
    let description: String     // Required. Describes the channel
    let link: String            // Required. Defines the hyperlink to the channel
    let title: String           // Required. Defines the title of the channel
    
    let items: [Item]
    
    // Optional
    
    let category: String?       // Optional. Defines one or more categories for the feed
    let cloud: String?          // Optional. Register processes to be notified immediately of updates of the feed
    let copyright: String?      // Optional. Notifies about copyrighted material
    let docs: String?           // Optional. Specifies a URL to the documentation of the format used in the feed
    let generator: String?      // Optional. Specifies the program used to generate the feed
    let image: Image?           // Optional. Allows an image to be displayed when aggregators present a feed
    let language: String?       // Optional. Specifies the language the feed is written in
    let lastBuildDate: String?  // Optional. Defines the last-modified date of the content of the feed
    let managingEditor: String? // Optional. Defines the e-mail address to the editor of the content of the feed
    let pubDate: String?        // Optional. Defines the last publication date for the content of the feed
    let rating: String?         // Optional. The PICS rating of the feed
    let skipDays: String?       // Optional. Specifies the days where aggregators should skip updating the feed
    let skipHours: String?      // Optional. Specifies the hours where aggregators should skip updating the feed
    let textInput: String?      // Optional. Specifies a text input field that should be displayed with the feed
    let ttl: String?            // Optional. Specifies the number of minutes the feed can stay cached before refreshing it from the source
    let webmaster: String?      // Optional. Defines the e-mail address to the webmaster of the feed
    
    // MARK: Structures
    
    struct Image {
        let link: String        // Required. Defines the hyperlink to the website that offers the channel
        let title: String       // Required. Defines the text to display if the image could not be shown
        let url: String         // Required. Defines the URL to the image
    }
    
    struct Item {
        
        // Required
        
        let description: String     // Required. Describes the item
        let link: String            // Required. Defines the hyperlink to the item
        let title: String           // Required. Defines the title of the item
        
        // Optional
        
        let author: String?         // Optional. Specifies the e-mail address to the author of the item
        let category: String?       // Optional. Defines one or more categories the item belongs to
        let comments: String?       // Optional. Allows an item to link to comments about that item
        let enclosures: [Enclosure]      // Optional. Allows a media file to be included with the item
        let guid: String?           // Optional. Defines a unique identifier for the item
        let pubDate: String?        // Optional. Defines the last-publication date for the item
        let source: String?         // Optional. Specifies a third-party source for the item
        
        // Structures
        
        struct Enclosure {
            let length: String      // Required. Defines the length (in bytes) of the media file
            let type: String        // Required. Defines the type of media file
            let url: String         // Required. Defines the URL to the media file
        }
    }
    
    // MARK: Computed Properties
}

//struct MutableRSSChannel { // Documentation credit: https://www.w3schools.com/xml/xml_rss.asp
//
//    // Required
//
//    func immutable() -> RSSChannel {
//
//    }
//
//    var description: String     // Required. Describes the channel
//    var link: String            // Required. Defines the hyperlink to the channel
//    var title: String           // Required. Defines the title of the channel
//
//    var items: [Item]
//
//    // Optional
//
//    var category: String?       // Optional. Defines one or more categories for the feed
//    var cloud: String?          // Optional. Register processes to be notified immediately of updates of the feed
//    var copyright: String?      // Optional. Notifies about copyrighted material
//    var docs: String?           // Optional. Specifies a URL to the documentation of the format used in the feed
//    var generator: String?      // Optional. Specifies the program used to generate the feed
//    var image: Image?           // Optional. Allows an image to be displayed when aggregators present a feed
//    var language: String?       // Optional. Specifies the language the feed is written in
//    var lastBuildDate: String?  // Optional. Defines the last-modified date of the content of the feed
//    var managingEditor: String? // Optional. Defines the e-mail address to the editor of the content of the feed
//    var pubDate: String?        // Optional. Defines the last publication date for the content of the feed
//    var rating: String?         // Optional. The PICS rating of the feed
//    var skipDays: String?       // Optional. Specifies the days where aggregators should skip updating the feed
//    var skipHours: String?      // Optional. Specifies the hours where aggregators should skip updating the feed
//    var textInput: String?      // Optional. Specifies a text input field that should be displayed with the feed
//    var ttl: String?            // Optional. Specifies the number of minutes the feed can stay cached before refreshing it from the source
//    var webmaster: String?      // Optional. Defines the e-mail address to the webmaster of the feed
//
//    // Structures
//
//    struct Image {
//        var link: String        // Required. Defines the hyperlink to the website that offers the channel
//        var title: String       // Required. Defines the text to display if the image could not be shown
//        var url: String         // Required. Defines the URL to the image
//    }
//
//    struct Item {
//
//        // Required
//
//        var description: String     // Required. Describes the item
//        var link: String            // Required. Defines the hyperlink to the item
//        var title: String           // Required. Defines the title of the item
//
//        // Optional
//
//        var author: String?         // Optional. Specifies the e-mail address to the author of the item
//        var category: String?       // Optional. Defines one or more categories the item belongs to
//        var comments: String?       // Optional. Allows an item to link to comments about that item
//        var enclosure: String?      // Optional. Allows a media file to be included with the item
//        var guid: String?           // Optional. Defines a unique identifier for the item
//        var pubDate: String?        // Optional. Defines the last-publication date for the item
//        var source: String?         // Optional. Specifies a third-party source for the item
//
//        // Structures
//
//        struct Enclosure {
//            var length: String      // Required. Defines the length (in bytes) of the media file
//            var type: String        // Required. Defines the type of media file
//            var url: String         // Required. Defines the URL to the media file
//        }
//    }
//}
