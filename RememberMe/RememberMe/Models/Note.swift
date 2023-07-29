//
//  Note.swift
//  RememberMe
//
//  Created by Consultant on 7/28/23.
//

import Foundation

struct Note: Identifiable, Equatable {
    var id: String = UUID().uuidString
    var title: String
    var text: String
    var date: Date

}
