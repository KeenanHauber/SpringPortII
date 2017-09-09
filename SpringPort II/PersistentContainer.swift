//
//  PersistentContainer.swift
//  OSXSpringLobby
//
//  Created by Belmakor on 4/07/2016.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Foundation
import CoreData

class PersistentContainer {

    enum StoreType {
        case sqLite
        case inMemory

        var typeName: String {
            switch self {
            case .sqLite: return NSSQLiteStoreType
            case .inMemory: return NSInMemoryStoreType
            }
        }
    }

    let managedObjectModel: NSManagedObjectModel
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    let viewContext: NSManagedObjectContext

    init(name: String, type: StoreType, storeURL: URL?) {
        let bundle = Bundle(for: PersistentContainer.self)
        guard let model = NSManagedObjectModel.mergedModel(from: [bundle]) else { fatalError("Core Data model not found") }
        managedObjectModel = model
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! persistentStoreCoordinator.addPersistentStore(ofType: type.typeName, configurationName: nil, at: storeURL, options: nil)
        viewContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }

}
