//
//  ContentViewModel.swift
//  RememberMe
//
//  Created by Andres D. Paladines on 7/28/23.
//

import Foundation

@MainActor
class ContentViewModel: ObservableObject {
    
    @Published var notesList: [Note] = []
    
    let context = PersistenceController.shared.container.newBackgroundContext()
    
    func getProductsListFromDB() async -> [Note]? {
        do {
            let coreDataManager = NotesPersistenceManager(context: context)
            let myDBList = try await coreDataManager.fetchDataFromDatabase()

            let productsList = myDBList.compactMap({Note(from: $0)})
            return productsList
        }catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func addNewNote() async {
        do {
            let newItem = Note(uuid: UUID().uuidString, titleString: "Tap to edit", bodyString: "", date: Date(), type: .sport)
            
            try await saveNotesListInDB(item: newItem)
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    func saveNotesListInDB(item: Note) async throws {
        let coreDataManager = NotesPersistenceManager(context: context)
        try await coreDataManager.saveDataIntoDatabase(item: item)
    }
    
    func update(note: Note) async {
        do {
            let notesDataGenericManager = NotesPersistenceManager(context: context)
            try await notesDataGenericManager.updateNoteEntity(with: note)
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    func delete(note: Note) async {
        do {
            let notesDataGenericManager = NotesPersistenceManager(context: context)
            try await notesDataGenericManager.deleteEntity(with: note)
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    
//    func getProductsListFromGenericDB() async {//} -> [Note]? {
//        do {
//            let coreDataGenericManager: GenericPersistenceManager = GenericPersistenceManager(context: context)
//            let coreDataManager = NotesPersistenceManager(context: context)
//            let productEntity = NoteEntity(context: context)
//            let myList = try await coreDataManager.fetchDataFromDatabase()
//
//            let myDBList = try await coreDataGenericManager.fetchDataFromDatabase(entity: productEntity)
//            let productsList = myDBList.compactMap({Note(from: $0)})
//            DispatchQueue.main.async {
////                return productsList
//                self.notesList = productsList
//            }
//        }catch let error {
//            print(error.localizedDescription)
////            return nil
//        }
//    }
    


}

