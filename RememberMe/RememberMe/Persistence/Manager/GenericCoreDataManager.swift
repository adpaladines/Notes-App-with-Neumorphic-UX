//
//  GenericCoreDataManager.swift
//  RememberMe
//
//  Created by Consultant on 7/28/23.
//

import Foundation
import CoreData



class GenericPersistenceManager: CoreDataGenericOperationsProtocol {

    typealias ItemType = [Note]
    

    func fetchDataFromDatabase<T: NSManagedObject>(entity: T) async throws -> [T] {
        try await PersistenceController.shared.container.performBackgroundTask { privateContext in
            guard let entityName = T.entity().name else {
                throw NSError(domain: "Invalid entity name", code: 0, userInfo: nil)
            }
            let request: NSFetchRequest<T> = NSFetchRequest<T>(entityName: entityName)
            let result = try privateContext.fetch(request)
            let newResult = result.filter({ $0.isFault })
            return newResult
        }
    }

    func clearData(entity: NSManagedObject) async throws {
        try await PersistenceController.shared.container.performBackgroundTask { privateContext in
            let myEntity = entity(context: privateContext)
//            guard let entityName = T.entity().name else {
//                throw NSError(domain: "Invalid entity name", code: 0, userInfo: nil)
//            }
            let request: NSFetchRequest<T> = NSFetchRequest<T>(entityName: entityName)
            let results = try privateContext.fetch(request)
            results.forEach { entity in
                privateContext.delete(entity)
            }
            try privateContext.save()
        }
    }

}
