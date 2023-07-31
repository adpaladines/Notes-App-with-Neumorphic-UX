//
//  GetString.swift
//  RememberMe
//
//  Created by andres paladines on 7/30/23.
//

import Foundation

class GetString {
    static let shared = GetString()
    
    func getMainTitleString(when isSearching: Bool) -> String {
        return isSearching ? "Searching Notes" : "All Notes"
    }
    
    func getMainBodyString(when isSearching: Bool) -> String {
        return isSearching ? "Looking for some specific note." : "Explore all notes you wrote."
    }
    
}

