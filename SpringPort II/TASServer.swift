//
//  TASServer.swift
//  OSXSpringLobby
//
//  Created by Belmakor on 30/06/2016.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Foundation

protocol ServerLoginDelegate: class {
    func server(_ server: TASServer, didLoginUserNamed name: String)
    func server(_ server: TASServer, didConnectToServerWithInfo info: LobbyServerInfo)
    func server(_ server: TASServer, didDenyLoginBecauseOf reason: String)
    func server(_ server: TASServer, didDenyRegisterBecauseOf reason: String)
    func registrationAccepted()
    
}

protocol ServerMessageDelegate: class {
    func server(_ server: TASServer, didReceive message: ServerMessage)
    func server(_ server: TASServer, didRecieve agreementComponent: String)
    func agreementEnd()
}

protocol ServerUsersDelegate: class {
    func server(_ server: TASServer, didAdd user: User)
    func server(_ server: TASServer, didRemoveUserNamed name: String)
    
    func server(_ server: TASServer, didSetStatus status: ClientStatus, forUserNamed username: String)
    func server(_ server: TASServer, didSetBattleStatus battleStatus: BattleStatus, forUserNamed username: String)
}

protocol ServerChannelDelegate: class {
    func server(_ server: TASServer, successfullyJoinedChannelNamed chanName: String)
    func server(_ server: TASServer, receivedMessageFromChannel chanName: String, fromUser username: String, withMessage message: String)
    func server(_ server: TASServer, receivedIRCStyleMessageFromChannel chanName: String, fromUser username: String, withMessage message: String)
    func server(_ server: TASServer, receivedJoinMessageFromChannel chanName: String, forUser username: String)
    func server(_ server: TASServer, receivedLeaveMessageFromChannel chanName: String, forUser username: String)
}

protocol ServerBattleListDelegate: class {
    func server(_ server: TASServer, didOpen battle: Battle)
    func server(_ server: TASServer, didCloseBattleWithId battleId: String)
    func server(_ server: TASServer, didUpdate battle: UpdatedBattleInfo)
    func server(_ server: TASServer, userNamed name: String, didJoinBattleWithId battleId: String)
    func server(_ server: TASServer, userNamed name: String, didLeaveBattleWithId battleId: String)
    func server(_ server: TASServer, didAcceptJoinOf battleID: String, withHash hash: String)
}

protocol ServerBattleDelegate: class {
    
    func server(_ server: TASServer, didReceiveScriptTagsAs message: String)
    func server(_ server: TASServer, recievedFromBattle message: String, from sender: String, ofStyle style: String)
    
    func server(_ server: TASServer, didSetBattleStatus battleStatus: BattleStatus, forUserNamed username: String)
    
    func server(_ server: TASServer, userNamed name: String, didJoinBattleWithId battleId: String)
    func server(_ server: TASServer, userNamed name: String, didLeaveBattleWithId battleId: String)

    
    func serverDidRequestBattleStatus()
    func registerBattleKick()
}

protocol ServerSomethingDelegate: class {
    func server(_ server: TASServer, instructedToConnectTo ipAndPort: String, with scriptPassword: String)
}

protocol ServerOtherDelegate: class {
    func server(_ server: TASServer, wasInstructedToJoin battleId: String, with password: String)
}

protocol ServerPrivateMessageDelegate: class {
    func server(_ server: TASServer, didRecieve privateMessage: String, from sender: String, of type: MessageType)
}

enum MessageType {
    case IRCStyle
    case Standard
}

/// A server command is a command given by the client to the server
protocol ServerCommand: CustomStringConvertible { }

/// Protocol is described at http://springrts.com/dl/LobbyProtocol
/// See here for an implementation in C++ https://github.com/cleanrock/flobby/tree/master/src/model
class TASServer: NSObject {
    var loginDelegates: [ServerLoginDelegate] = []
    var messageDelegates: [ServerMessageDelegate] = []
    var usersDelegates: [ServerUsersDelegate] = []
    var channelDelegates: [ServerChannelDelegate] = []
    var battleListDelegates: [ServerBattleListDelegate] = []
    var battleDelegates: [ServerBattleDelegate] = []
    var somethingDelegates: [ServerSomethingDelegate] = []
    var otherDelegates: [ServerOtherDelegate] = []
    var privateMessageDelegates: [ServerPrivateMessageDelegate] = []
    

//    let name: String
    let socket: Socket

    init(name: String, address: String, port: Int) {
//        self.name = name
        socket = Socket(address: address, port: port)

        super.init()

        socket.delegate = self
    }

    func connect() {
        socket.connect()
    }

    func disconnect() {
        socket.disconnect()
    }

    func send(_ command: ServerCommand) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(TASServer.sendPing), object: nil)
        socket.send(message: "\(command.description)\n")
//        print("Sending message to server: \(command.description)")
        perform(#selector(TASServer.sendPing), with: nil, afterDelay: 30)
    }

    func sendPing() {
        socket.send(message: "PING\n")
        perform(#selector(TASServer.sendPing), with: nil, afterDelay: 30)
    }
}

extension TASServer: SocketDelegate {

    func socket(_ socket: Socket, didReceive message: String) {
        let messages = message.components(separatedBy: "\n")
        for message in messages {
            process(message: message)
        }
    }
// ########################################################################################################################################################################################################################
    fileprivate func process(message: String) {
        guard !message.isEmpty else { return }
//        print(message)

        let components = message.components(separatedBy: " ")

        // TODO: support optional #id prefix to messages
        guard let commandName = components.first?.uppercased() else { return }
        
                    // MARK: PROCESSING MESSAGES #####################################################################
        
        switch commandName {


            // MARK: SERVER MESSAGES #####################################################################

        case "TASSERVER":
            guard let serverInfo = LobbyServerInfo(messageComponents: components) else { break }
            for delegate in loginDelegates {
                delegate.server(self, didConnectToServerWithInfo: serverInfo)
            }

        case "ACCEPTED":
            guard components.count == 2 else { break }
            let username = components[1]
            for delegate in loginDelegates {
                delegate.server(self, didLoginUserNamed: username)
            }
            
            
        case "DENIED":
            guard components.count > 1 else { break }
            let reason = message
            for delegate in loginDelegates {
                delegate.server(self, didDenyLoginBecauseOf: reason)
            }

        case "SERVERMSG", "MOTD", "BROADCAST":
            guard let serverMessage = ServerMessage(type: commandName, message: message) else { break }
            for delegate in messageDelegates {
                delegate.server(self, didReceive: serverMessage)
            }
            debugPrint(components.joined(separator: " "))
        case "LOGININFOEND":
            break

        case "PONG":
            break // nothing


            // MARK: USERS #####################################################################

        case "ADDUSER":
            guard let user = User(message: message) else { break }
            for delegate in usersDelegates {
                delegate.server(self, didAdd: user)
            }

        case "REMOVEUSER":
            guard components.count == 2 else { break }
            let username = components[1]
            for delegate in usersDelegates {
                delegate.server(self, didRemoveUserNamed: username)
            }

        case "CLIENTSTATUS":
            // CLIENTSTATUS userName status
            guard components.count == 3 else { break }
            let username = components[1]
            let status = ClientStatus(statusString: components[2])
            for delegate in usersDelegates {
                delegate.server(self, didSetStatus: status, forUserNamed: username)
            }

            // MARK: BATTLES #####################################################################

        case "BATTLEOPENED":
            guard let battle = Battle(message: message) else { break }
            for delegate in battleListDelegates {
                delegate.server(self, didOpen: battle)
            }

        case "BATTLECLOSED":
            guard components.count == 2 else { break }
            let battleId = components[1]
            for delegate in battleListDelegates {
                delegate.server(self, didCloseBattleWithId: battleId)
            }

        case "UPDATEBATTLEINFO":
            // UPDATEBATTLEINFO battleID spectatorCount locked mapHash {mapName}
            guard let updatedBattleInfo = UpdatedBattleInfo(components: components) else { break }
            for delegate in battleListDelegates {
                delegate.server(self, didUpdate: updatedBattleInfo)
            }

        case "JOINEDBATTLE":
            // JOINEDBATTLE battleID userName [scriptPassword]
            guard components.count >= 3 else { break }
            let battleId = components[1]
            let username = components[2]
            for delegate in battleListDelegates {
                delegate.server(self, userNamed: username, didJoinBattleWithId: battleId)
            }
            for delegate in battleDelegates {
                delegate.server(self, userNamed: username, didJoinBattleWithId: battleId)
            }

        case "LEFTBATTLE":
            // LEFTBATTLE battleID userName
            guard components.count == 3 else { break }
            let battleId = components[1]
            let username = components[2]
            for delegate in battleListDelegates {
                delegate.server(self, userNamed: username, didLeaveBattleWithId: battleId)
            }
            for delegate in battleDelegates {
                delegate.server(self, userNamed: username, didLeaveBattleWithId: battleId)
            }

            
        case "JOINBATTLE":
            // JOINBATTLE battleID hashCode
            guard components.count == 3 else { break }
            let battleID = components[1]
            let hash = components[2]
            for delegate in battleListDelegates {
                delegate.server(self, didAcceptJoinOf: battleID, withHash: hash)
            }
            
        case "SETSCRIPTTAGS":
            // SETSCRIPTTAGS {pair1} [{pair2}] etc…
            guard components.count == 2 else {
//                print("parts:\(components.count)")
                break
            }
            let message = components[1]
            for delegate in battleDelegates {
                delegate.server(self, didReceiveScriptTagsAs: message)
            }
                
        case "CLIENTBATTLESTATUS":
            // CLIENTBATTLESTATUS username battleStatus teamColor
            guard components.count == 4 else {
                break
            }
            let battleStatus = BattleStatus(components[2], withColor: components[3])
//            print(components.joined(separator: "###"))
            for delegate in battleDelegates {
            delegate.server(self, didSetBattleStatus: battleStatus, forUserNamed: components[1])
            }
            for delegate in usersDelegates {
                delegate.server(self, didSetBattleStatus: battleStatus, forUserNamed: components[1])
            }
            
        case "REQUESTBATTLESTATUS":
            for delegate in battleDelegates {
                delegate.serverDidRequestBattleStatus()
            }
            
            // MARK: CHANNELS #####################################################################
            
        case "JOIN":
            // JOIN chanName
            guard components.count == 2 else { break }
            let chanName = components[1]
            for delegate in channelDelegates {
                delegate.server(self, successfullyJoinedChannelNamed: chanName)
            }
                
        case "SAID":
            // SAID chanName userName {message}
            guard components.count > 3 else {
                break
            }
            let chanName = components[1]
            let username = components[2]
            let message = components[3..<components.count].joined(separator: " ")
            // print("Received message: \(message)")
            for delegate in channelDelegates {
                delegate.server(self, receivedMessageFromChannel: chanName, fromUser: username, withMessage: message)
            }
            
        case "SAIDEX":
            // SAIDEX chanName userName {message}
            guard components.count > 3 else { break }
            let chanName = components[1]
            let sender = components[2]
            let message = components[3..<components.count].joined(separator: " ")
            for delegate in channelDelegates {
                delegate.server(self, receivedIRCStyleMessageFromChannel: chanName, fromUser: sender, withMessage: message)
            }
            
        case "JOINED":
            // JOINED chanName username
            guard components.count == 3 else { break }
            let chanName = components[1]
            let username = components[2]
            for delegate in channelDelegates {
                delegate.server(self, receivedJoinMessageFromChannel: chanName, forUser: username)
            }
            
        case "CLIENTS":
            // CLIENTS chanName {usernames}
            guard components.count > 2 else { break }
            let chanName = components[1]
            for component in components[2..<components.count] {
                let username = component
                for delegate in channelDelegates {
                    delegate.server(self, receivedJoinMessageFromChannel: chanName, forUser: username)
                }
            }
            
        case "LEFT":
            // LEFT chanName username {reason}
            guard components.count > 2 else { break }
            let chanName = components[1]
            let username = components[2]
            for delegate in channelDelegates {
                delegate.server(self, receivedLeaveMessageFromChannel: chanName, forUser: username)
            }
            
        case "SAIDBATTLE":
            guard components.count > 2 else { break }
            let sender = components[1]
            let message = components[2..<components.count].joined(separator: " ")
            for delegate in battleDelegates {
                delegate.server(self, recievedFromBattle: message, from: sender, ofStyle: "Standard")
            }
            
        case "SAIDBATTLEEX":
            guard components.count > 2 else { break }
            let sender = components[1]
            let message = components[2..<components.count].joined(separator: " ")
            for delegate in battleDelegates {
                delegate.server(self, recievedFromBattle: message, from: sender, ofStyle: "IRCStyle")
            }
            
        case "FORCEQUITBATTLE":
            for delegate in battleDelegates {
                delegate.registerBattleKick()
            }
            
        case "CONNECTUSER":
            guard components.count > 1 else { break }
            let ipAndPort = components[1]
            let scriptPassword = components[2]
            for delegate in somethingDelegates {
                delegate.server(self, instructedToConnectTo: ipAndPort, with: scriptPassword)
            }
            
        case "FORCEJOINBATTLE":
            guard components.count > 1 else { break }
            let battleId = components[1]
            let battlePassword = components[2]
            for delegate in otherDelegates {
            delegate.server(self, wasInstructedToJoin: battleId, with: battlePassword)
            }
            
        case "AGREEMENT":
            let agreementComponent = components[1..<components.count].joined(separator: " ")
            for delegate in messageDelegates {
                delegate.server(self, didRecieve: agreementComponent)
            }
            
        case "AGREEMENTEND":
            for delegate in messageDelegates {
                delegate.agreementEnd()
            }
            
        case "REGISTRATIONDENIED":
//            print(components.joined(separator: "@@"))
            let reason = components[1..<components.count].joined(separator: " ")
            for delegate in loginDelegates {
                delegate.server(self, didDenyRegisterBecauseOf: reason)
            }
            
        case "REGISTRATIONACCEPTED":
            for delegate in loginDelegates {
                delegate.registrationAccepted()
            }
            
        case "SAIDPRIVATE":
            guard components.count > 2 else { break }
            let privateMessage = components[2..<components.count].joined(separator: " ")
            let sender = components[1]
            for delegate in privateMessageDelegates {
                delegate.server(self, didRecieve: privateMessage, from: sender, of: .Standard)
            }
            
        case "SAIDPRIVATEEX":
            guard components.count > 2 else { break }
            let privateMessage = components[2..<components.count].joined(separator: " ")
            let sender = components[1]
            for delegate in privateMessageDelegates {
                delegate.server(self, didRecieve: privateMessage, from: sender, of: .IRCStyle)
            }
        default:
            debugPrint("Unrecognised command: \(components.joined(separator: ""))")
        }
        
        
    }
}
