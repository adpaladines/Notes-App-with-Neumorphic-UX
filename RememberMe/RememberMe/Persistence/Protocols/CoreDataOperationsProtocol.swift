//
//  CoreDataOperationsProtocol.swift
//  RememberMe
//
//  Created by Consultant on 7/28/23.
//

import Foundation

protocol CoreDataOperationsProtocol {
    associatedtype ItemType
    associatedtype ManagedObjectType
    
    func saveDataIntoDatabase<ItemType>(items: [ItemType]) async throws

    
}

