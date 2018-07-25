//
//  TASServer.swift
//  OSXSpringLobby
//
//  Created by Belmakor on 30/06/2016.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Foundation

/// A server command is a command given by the client to the server
protocol ServerCommand: CustomStringConvertible { }

/// Protocol is described at http://springrts.com/dl/LobbyProtocol
/// See here for an implementation in C++ https://github.com/cleanrock/flobby/tree/master/src/model
class TASServer: NSObject {
    weak var loginListener: LoginListening?
    
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
        perform(#selector(TASServer.sendPing), with: nil, afterDelay: 30)
    }
    
    @objc func sendPing() {
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
    // ###################################################################################
    fileprivate func process(message: String) {
        guard !message.isEmpty else { return }
        //        print(message)
        let components = message.components(separatedBy: " ")
        
        // TODO: support optional #id prefix to messages
        guard let commandName = components.first?.uppercased() else { return }
        
        // MARK: PROCESSING MESSAGES #####################################################
        
        switch commandName {
            
        // MARK: SERVER MESSAGES #########################################################
        case "TASSERVER":
            guard let serverInfo = LobbyServerInfo(messageComponents: components) else { break }
            loginListener?.connectedSuccessfully()
            
        case "ACCEPTED":
            guard components.count == 2 else { break }
            let username = components[1]
            loginListener?.loginAccepted()
            
        case "DENIED":
            guard components.count > 1 else { break }
            let error = message
            loginListener?.loginDenied(error)
            
        case "SERVERMSG", "MOTD", "BROADCAST":
            guard let serverMessage = ServerMessage(type: commandName, message: message) else { break }
        //            debugPrint(components.joined(separator: " "))
        case "LOGININFOEND":
            break
            
        case "PONG":
            break // nothing
            
        // MARK: USERS ###################################################################
        case "ADDUSER":
            guard let user = User(message: message) else { break }
            
        case "REMOVEUSER":
            guard components.count == 2 else { break }
            let username = components[1]
            
        case "CLIENTSTATUS":
            // CLIENTSTATUS userName status
            guard components.count == 3 else { break }
            let username = components[1]
            let status = ClientStatus(statusString: components[2])
            
            // MARK: BATTLES #############################################################
            
        case "PROMOTE":
            guard components.count == 2 else { break }
            debugPrint("Promote requested for battle of ID \(components[1])")
            
        case "BATTLEOPENED":
            guard let battle = Battle(message: message) else { break }
            
        case "BATTLECLOSED":
            guard components.count == 2 else { break }
            let battleId = components[1]
            
        case "UPDATEBATTLEINFO":
            // UPDATEBATTLEINFO battleID spectatorCount locked mapHash {mapName}
            guard let updatedBattleInfo = UpdatedBattleInfo(components: components) else { break }
            
        case "JOINEDBATTLE":
            // JOINEDBATTLE battleID userName [scriptPassword]
            guard components.count >= 3 else { break }
            let battleId = components[1]
            let username = components[2]
            
        case "LEFTBATTLE":
            // LEFTBATTLE battleID userName
            guard components.count == 3 else { break }
            let battleId = components[1]
            let username = components[2]
            
            
        case "JOINBATTLE":
            // JOINBATTLE battleID hashCode
            guard components.count == 3 else { break }
            let battleID = components[1]
            let hash = components[2]
            
        case "SETSCRIPTTAGS":
            // SETSCRIPTTAGS {pair1} [{pair2}] etc…
            guard components.count == 2 else {
                break
            }
            let message = components[1]
            
        case "CLIENTBATTLESTATUS":
            // CLIENTBATTLESTATUS username battleStatus teamColor
            guard components.count == 4 else {
                break
            }
            let battleStatus = BattleStatus(components[2], withColor: components[3])
            
        case "REQUESTBATTLESTATUS":
            break
            
            // MARK: CHANNELS ############################################################
            
        case "JOIN":
            // JOIN chanName
            guard components.count == 2 else { break }
            let chanName = components[1]
            
        case "SAID":
            // SAID chanName userName {message}
            guard components.count > 3 else {
                break
            }
            let chanName = components[1]
            let username = components[2]
            let message = components[3..<components.count].joined(separator: " ")
            
        case "SAIDEX":
            // SAIDEX chanName userName {message}
            guard components.count > 3 else { break }
            let chanName = components[1]
            let sender = components[2]
            let message = components[3..<components.count].joined(separator: " ")
            
        case "JOINED":
            // JOINED chanName username
            guard components.count == 3 else { break }
            let chanName = components[1]
            let username = components[2]
            
        case "CLIENTS":
            // CLIENTS chanName {usernames}
            guard components.count > 2 else { break }
            let chanName = components[1]
            for component in components[2..<components.count] {
                let username = component
            }
            
        case "LEFT":
            // LEFT chanName username {reason}
            guard components.count > 2 else { break }
            let chanName = components[1]
            let username = components[2]
            
        case "SAIDBATTLE":
            guard components.count > 2 else { break }
            let sender = components[1]
            let message = components[2..<components.count].joined(separator: " ")
            
        case "SAIDBATTLEEX":
            guard components.count > 2 else { break }
            let sender = components[1]
            let message = components[2..<components.count].joined(separator: " ")
            
        case "FORCEQUITBATTLE":
            break
            
        case "CONNECTUSER":
            guard components.count > 1 else { break }
            let ipAndPort = components[1]
            let scriptPassword = components[2]
            
        case "FORCEJOINBATTLE":
            guard components.count > 1 else { break }
            let battleId = components[1]
            let battlePassword = components[2]
            
        case "AGREEMENT":
            let agreementComponent = components[1..<components.count].joined(separator: " ")
            
        case "AGREEMENTEND":
            break
            
        case "REGISTRATIONDENIED":
            let reason = components[1..<components.count].joined(separator: " ")
            
        case "REGISTRATIONACCEPTED":
            break
            
        case "SAIDPRIVATE":
            guard components.count > 2 else { break }
            let privateMessage = components[2..<components.count].joined(separator: " ")
            let sender = components[1]
            
        case "SAIDPRIVATEEX":
            guard components.count > 2 else { break }
            let privateMessage = components[2..<components.count].joined(separator: " ")
            let sender = components[1]
        default:
            //            debugPrint("Unrecognised command: \(components.joined(separator: ""))")
            break
        }
        
        
    }
}
