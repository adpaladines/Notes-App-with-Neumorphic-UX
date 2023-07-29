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

    func getProductsListFromGenericDB() async -> [Note]? {
        do {
            let coreDataGenericManager: GenericPersistenceManager = GenericPersistenceManager(context: context)
            let productEntity = NoteEntity(context: coreDataGenericManager.context)
            let myDBList = try await coreDataGenericManager.fetchDataFromDatabase(entity: productEntity)
            let productsList = myDBList.compactMap({Note(from: $0)})
            return productsList
        }catch let error {
            print(error.localizedDescription)
        }
        return []
    }
    
    func addNewNote() async {
        do {
            let newItem = Note(uuid: UUID().uuidString, titleString: "My Title", bodyString: "Lorem Ipsum Body", date: Date(), type: .sport)
            
            try await saveNotesListInDB(item: newItem)
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    func saveNotesListInDB(item: Note) async throws {
        let coreDataManager = NotesPersistenceManager(context: context)
        try await coreDataManager.saveDataIntoDatabase(item: item)
    }

}

