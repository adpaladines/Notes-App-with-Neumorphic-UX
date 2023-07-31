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
    
    func fetchSingleItemFromDatabase(uuid: String) async throws -> NoteEntity? {
        let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        let predicate = NSPredicate(format: "uuid == %@", uuid)
        fetchRequest.predicate = predicate
        let result = try context.fetch(fetchRequest).first
        return result
    }
    
    func fetchDataFromDatabase() async throws -> [NoteEntity] {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        let result = try context.fetch(request)
        return result
    }
    
    func getItemDataFromDatabase() async throws -> NoteEntity {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        let result = try context.fetch(request).first!
        return result
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
    
    func updateNoteEntity(with uuid: String, titleString: String, bodyString: String) async throws {
        guard let noteEntity = try await fetchSingleItemFromDatabase(uuid: uuid) else {
            print("NoteEntity with UUID: \(uuid) not found.")
            return
        }
        noteEntity.titleString = titleString
        noteEntity.bodyString = bodyString
        noteEntity.dateUpdate = Date()
        try context.save()
    }
    
    func updateNoteEntity(with note: Note) async throws {
        guard let noteEntity = try await fetchSingleItemFromDatabase(uuid: note.uuid) else {
            print("NoteEntity with UUID: \(note.uuid) not found.")
            return
        }
        noteEntity.titleString = note.titleString
        noteEntity.bodyString = note.bodyString
        noteEntity.dateUpdate = Date()
        try context.save()
    }
    
    func deleteEntity(with note: Note) async throws{
        guard let noteEntity = try await fetchSingleItemFromDatabase(uuid: note.uuid) else {
            print("NoteEntity with UUID: \(note.uuid) not found.")
            return
        }
        context.delete(noteEntity)
        try context.save()
//        print("Note with uuid: \(note.uuid), deleted!")
    }
    
    func deleteAllRecords() async throws {
        let coreDataGenericManager: GenericPersistenceManager = GenericPersistenceManager(context: context)
        try await coreDataGenericManager.clearData(entityType: NoteEntity.self)
    }
}
