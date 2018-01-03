//
//  ChannelDataController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 25/3/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//

import Cocoa

protocol ChannelDataControllerDelegate: ServerCommandRouter {
    func requestToJoin(_ channel: String)
}

protocol ChannelDataSource: class {
    func channelUsers() -> [User]
    func channelUserCount() -> Int
    func channelName(for index: Int) -> String
}

protocol ChannelDataOutput: class {
    func channelListUpdated(_ count: Int)
    func newChatLogForSelectedChannel(_ log: NSAttributedString)
    func playerListUpdated()
}

class ChannelDataController: ServerChannelDelegate, ChannelDataSource {
    weak var delegate: ChannelDataControllerDelegate!
    weak var output: ChannelDataOutput?
    
    var channels: [Channel] = []
    var autoJoinChannels: [String] = ["main", "ba", "newbies"]
    var selectedChannel: String = "newbies"
    
    func requestToJoinChannels() {
        for channel in autoJoinChannels {
            delegate?.requestToJoin(channel)
        }
    }
    
    func server(_ server: TASServer, successfullyJoinedChannelNamed chanName: String) {
        channels.append(Channel(name: chanName))
		selectedChannel = chanName // Was: (channels.last?.name)!
        output?.channelListUpdated(channels.count)
		// TODO: -- Work out why the following code is commented out
//        mainWindowController.channelSegmentedControl.segmentCount = channels.count
//        for index in 0..<channels.count {
//            mainWindowController.channelSegmentedControl.setLabel(channels[index].name, forSegment: index)
//        }
    }
    func server(_ server: TASServer, receivedMessageFromChannel chanName: String, fromUser username: String, withMessage message: String) { // SHould change username to sender // Also should work it so that all of these chat messages come through the same feed
        let msg = Message(timeStamp: timeStamp(), sender: username, message: message, style: "Standard")
        channels
            .filter { $0.name == chanName }
            .forEach { channel in
                channel.messages.append(msg)
                if channel.name == selectedChannel {
                    setChatLog(for: channel.name)
                }
        }
    }
    func server(_ server: TASServer, receivedIRCStyleMessageFromChannel chanName: String, fromUser username: String, withMessage message: String) {
        let msg = Message(timeStamp: timeStamp(), sender: username, message: message, style: "IRCStyle")
        channels
            .filter { $0.name == chanName }
            .forEach { channel in
                channel.messages.append(msg)
                if channel.name == selectedChannel {
                    setChatLog(for: channel.name)
                }
                
        }
        
    }
    func server(_ server: TASServer, receivedJoinMessageFromChannel chanName: String, forUser username: String) {
        channels
            .filter { $0.name == chanName }
            .forEach { channel in
                channel.users.append(username)
                channel.users.sort { $0 < $1 }
                
                channel.messages.append(Message(timeStamp: timeStamp(), sender: "Server", message: "\(username) joined the channel.", style: "Server"))
                if channel.name == selectedChannel {
                    setChatLog(for: channel.name)
                    output?.playerListUpdated()
                }
        }
    }
    func server(_ server: TASServer, receivedLeaveMessageFromChannel chanName: String, forUser username: String) {
        channels
            .filter { $0.name == chanName }
            .forEach { channel in
                channel.users = channel.users.filter { $0 != username }
                channel.messages.append(Message(timeStamp: timeStamp(), sender: "Server", message: "\(username) left the channel.", style: "Server"))
                if channel.name == selectedChannel {
                    setChatLog(for: channel.name)
                    output?.playerListUpdated()
                }
        }
        
    }
    
    func setChatLog(for channel: String) {
        var channelLog = NSAttributedString()
        channels
            .filter { $0.name == channel }
            .forEach {  channel in
                channelLog = chatLog(for: channel)
        }
        output?.newChatLogForSelectedChannel(channelLog)
        
    }
    
    func chatLog(for channel: Channel) -> NSAttributedString {// Essentially the same over in BattleroomController.swift
        let log = NSMutableAttributedString()
        for message in channel.messages {
            switch message.style {
            case "Standard":
                let messageAsString = "[\(message.timeStamp)] <\(message.sender)> \(message.message)\n"
                let messageAsNSAttributedString = NSAttributedString(string: messageAsString, attributes: [NSAttributedStringKey.foregroundColor : NSColor.orange] )
                log.append(messageAsNSAttributedString)
                
            case "IRCStyle":
                let messageAsString = "[\(message.timeStamp)] \(message.sender) \(message.message)\n"
                let messageAsNSAttributedString = NSAttributedString(string: messageAsString, attributes: [NSAttributedStringKey.foregroundColor : NSColor.magenta] )
                log.append(messageAsNSAttributedString)
                
            case "Server":
                let messageAsString = "[\(message.timeStamp)] ### \(message.sender) ### \(message.message)\n"
                let messageAsNSAttributedString = NSAttributedString(string: messageAsString, attributes: [NSAttributedStringKey.foregroundColor : NSColor.blue] )
                log.append(messageAsNSAttributedString)
                
            default:
                break
            }
            
        }
        
        return log
    }
    /////////////////////////////
    // MARK: ChannelDataSource //
    /////////////////////////////
    func channelUsers() -> [User] {
        var channelUserNames: [String] = []
        var channelUsers: [User] = []
        channels
            .filter { $0.name == selectedChannel }
            .forEach { channel in
                channelUserNames = channel.users
        }
        for username in channelUserNames {
            if let user = delegate?.find(user: username) {
                channelUsers.append(user)
            }
        }
        return channelUsers
    }
    
    func channelName(for index: Int) -> String {
        return channels[index].name
    }
    
    func channelUserCount() -> Int { // Find a neater way of doing this please
        var channelUserNames: [String] = []
        channels
            .filter { $0.name == selectedChannel }
            .forEach { channel in
                channelUserNames = channel.users
        }
        return channelUserNames.count
    }
    ////////////////////////////
    // MARK: Public Functions //
    ////////////////////////////
    public func setSelectedChannel(as index: Int) {
        selectedChannel = channels[index].name
        setChatLog(for: selectedChannel)
        
    }
    
    public func getSelectedChannel() -> String {
        return selectedChannel
    }
}
