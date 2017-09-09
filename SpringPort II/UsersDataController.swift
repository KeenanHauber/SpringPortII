//
//  UsersDataController.swift
//  SpringPort II
//
//  Created by MasterBel2 on 25/3/17.
//  Copyright © 2017 MasterBel2. All rights reserved.
//


// TODO: - Sort the player lists!
import Cocoa
protocol UsersDataControllerDelegate: ServerCommandRouter {
    func userWentIngame(_ username: String)
    func getUsername() -> String
}

protocol UsersDataSource: class {
    func user(at row: Int) -> User
    func userCount() -> Int
}

protocol UsersDataOutput: class {
    func userListUpdated()
    func userInfoUpdated(to status: ClientStatus)
}

class UsersDataController: ServerUsersDelegate {
    weak var delegate: UsersDataControllerDelegate!
    weak var output: UsersDataOutput?
    
    var users: [User] = []
    func server(_ server: TASServer, didAdd user: User) {
        users.append(user)
        output?.userListUpdated()
    }
    func server(_ server: TASServer, didRemoveUserNamed name: String) {
        users = users.filter { $0.username != name }
        output?.userListUpdated()
    }
    
    func server(_ server: TASServer, didSetStatus status: ClientStatus, forUserNamed username: String) {
        if status.isInGame == true, find(user: username)?.status.isInGame == false { // Umm… what about the case where he was already ingame?
            delegate?.userWentIngame(username)
        }
        
        users
            .filter { $0.username == username }
            .forEach { user in
                user.status = status
                if user.username == delegate?.getUsername() {
                    output?.userInfoUpdated(to: status)
                }
        }
        output?.userListUpdated()
    }
    func server(_ server: TASServer, didSetBattleStatus battleStatus: BattleStatus, forUserNamed username: String) {
        users
            .filter { $0.username == username }
            .forEach { user in
                user.battleStatus = battleStatus
        }
    }
    
    func find(user username: String) -> User? {
        let user = users.filter { $0.username == username }
        return user[0]
    }
}

extension UsersDataController: UsersDataSource {
    func user(at row: Int) -> User {
        return users[row]
    }
    func userCount() -> Int {
        return users.count
    }
}
