//
//  CoreDataOperationsProtocol.swift
//  RememberMe
//
//  Created by Andres D. Paladines on 7/28/23.
//

import Foundation

protocol CoreDataOperationsProtocol {
    associatedtype ItemType
    associatedtype ManagedObjectType
    
    func saveDataIntoDatabase<ItemType>(items: [ItemType]) async throws

    
}

