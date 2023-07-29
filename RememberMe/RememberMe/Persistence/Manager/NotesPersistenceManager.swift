//
//  NotesPersistenceManager.swift
//  RememberMe
//
//  Created by Andres D. Paladines on 7/28/23.
//

import Foundation
import CoreData

class NotesPersistenceManager: CoreDataOperationsProtocol {

    typealias ItemType = [Note]
    
    let context: NSManagedObjectContext
    
    required init(context: NSManagedObjectContext) {
        self.context = context
    }

    func saveDataIntoDatabase(item: Note) async throws {
        let noteEntity = NoteEntity(context: context)
        noteEntity.uuid = item.uuid
        noteEntity.titleString = item.titleString
        noteEntity.bodyString = item.bodyString
        noteEntity.date = item.date
        noteEntity.type = item.type.rawValue
        
        do {
            try context.save()
        }catch let error {
            print(error.localizedDescription)
        }
    }

    func deleteAllRecords() async throws {
        let coreDataGenericManager: GenericPersistenceManager = GenericPersistenceManager(context: context)
        try await coreDataGenericManager.clearData(entityType: NoteEntity.self)
    }
}
