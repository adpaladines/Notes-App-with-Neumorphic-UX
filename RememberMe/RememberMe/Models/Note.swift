//
//  Note.swift
//  RememberMe
//
//  Created by Andres D. Paladines on 7/28/23.
//

import Foundation

enum NoteType: String, CaseIterable {
    case utility
    case home
    case work
    case sport
    case other
    case birthday
    case holyday
    case grocery
    case all
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
    
    init(note: Note, titleString: String, bodyString: String, type: NoteType) {
        self.uuid = note.uuid
        self.titleString = titleString
        self.bodyString = bodyString
        self.date = note.date
        self.type = note.type
    }
    
}
