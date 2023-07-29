//
//  ContentViewModel.swift
//  RememberMe
//
//  Created by Consultant on 7/28/23.
//

import Foundation

@MainActor
class ContentViewModel: ObservableObject {
    @Published var notesList: [Note] = []

    func saveProducsListInDB(items: [Note]) async throws {
        let coreDataManager = NotesPersistenceManager()
        try await coreDataManager.saveDataIntoDatabase(items: items)
    }

    func getProductsListFromGenericDB() async -> [Note]? {
        do {
            
        }catch let error {
            print(error.localizedDescription)
        }
        return []
    }

}

