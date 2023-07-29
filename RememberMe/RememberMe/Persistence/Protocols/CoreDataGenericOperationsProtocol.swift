//
//  CoreDataGenericOperationsProtocol.swift
//  RememberMe
//
//  Created by Andres D. Paladines on 7/28/23.
//

import Foundation
import CoreData

protocol CoreDataGenericOperationsProtocol {

//    associatedtype ItemType
//    
//
//    func saveDataIntoDatabase<ItemType>(items: [ItemType]) async throws
    func fetchDataFromDatabase<T: NSManagedObject>(entity: T) async throws -> [T]
    func clearData(entity: NSManagedObject) async throws

}
