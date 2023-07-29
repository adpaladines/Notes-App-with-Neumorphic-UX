//
//  Note.swift
//  RememberMe
//
//  Created by Andres D. Paladines on 7/28/23.
//

import Foundation

enum NoteType: String {
    case utility
    case home
    case work
    case sport
    case other
}

struct Note: Identifiable, Equatable {
    var id: String = UUID().uuidString
    var uuid: String
    var titleString: String
    var bodyString: String
    var date: Date
    var type: NoteType
    
    init(uuid: String, titleString: String, bodyString: String, date: Date, type: NoteType) {
        self.uuid = uuid
        self.titleString = titleString
        self.bodyString = bodyString
        self.date = date
        self.type = type
    }
    
    init?(from item: NoteEntity) {
        guard let entityUuid = item.uuid else {
            return nil
        }
        
        self.uuid = entityUuid
        self.titleString = item.titleString ?? ""
        self.bodyString = item.bodyString ?? ""
        self.date = item.date ?? Date()
        self.type = NoteType(rawValue: item.type ?? "other") ?? .other
    }
    
    init?(uuid: String, titleString: String?, bodyString: String?, date: Date, type: NoteType) {
            guard let titleString = titleString, !titleString.isEmpty,
                  let bodyString = bodyString, !bodyString.isEmpty else {
                return nil
            }
            
            self.uuid = uuid
            self.titleString = titleString
            self.bodyString = bodyString
            self.date = date
            self.type = type
        }

}
