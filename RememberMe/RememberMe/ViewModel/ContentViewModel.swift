//
//  ContentViewModel.swift
//  RememberMe
//
//  Created by Andres D. Paladines on 7/28/23.
//

import Foundation

@MainActor
class ContentViewModel: ObservableObject {
    
    @Published var lisIsEven: Bool = false
    
    let context = PersistenceController.shared.container.newBackgroundContext()
    
    typealias evenOddLists = ( [Note], [Note] )
    
    func getProductsListFromDB() async -> evenOddLists {
        do {
            let coreDataManager = NotesPersistenceManager(context: context)
            let myDBList = try await coreDataManager.fetchDataFromDatabase()

            let productsList = myDBList.compactMap({Note(from: $0)})
            
            var leftList = [Note]()
            var rightList = [Note]()
            var index = 0
            productsList.forEach { note in
                if index.isEven {
                    leftList.append(note)
                }else {
                    rightList.append(note)
                }
                index += 1
            }
            lisIsEven = productsList.isEven
            return (leftList, rightList)
        }catch let error {
            print(error.localizedDescription)
            return ([], [])
        }
    }
    
    func add(new note: Note) async {
        do {
            try await saveNotesListInDB(item: note)
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    func saveNotesListInDB(item: Note) async throws {
        let coreDataManager = NotesPersistenceManager(context: context)
        try await coreDataManager.saveDataIntoDatabase(item: item)
    }
    
    func updateNoteWith(with uuid: String, titleString: String, bodyString: String) async {
        do {
            let notesDataGenericManager = NotesPersistenceManager(context: context)
            try await notesDataGenericManager.updateNoteEntity(with: uuid, titleString: titleString, bodyString: bodyString)
        }catch let error {
            print(error.localizedDescription)
        }
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

