//
//  NotesPersistenceManager.swift
//  RememberMe
//
//  Created by Consultant on 7/28/23.
//

import Foundation
import CoreData

class NotesPersistenceManager: CoreDataOperationsProtocol {

    typealias ItemType = Note
    typealias ManagedObjectType = NoteEntity

    func saveDataIntoDatabase<ItemType>(items: ItemType) async throws {
        try await deleteAllRecords()

    }


    func deleteAllRecords() async throws {
        do {
            let coreDataGenericManager: GenericPersistenceManager = GenericPersistenceManager()
            
            try await coreDataGenericManager.clearData(entity: NoteEntitry)
        }catch let error {
            print(error.localizedDescription)
        }
    }
}
