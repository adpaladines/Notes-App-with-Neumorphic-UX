//
//  SingletonDesignPattern.swift
//  DesignPatterns
//
//  Created by Andres D. Paladines on 7/27/23.
//

/*
 Singleton Pattern
 It ensures that only one object of class will be there thoroutghout our app
 It provides global access to that instance

 DataManager
 AuthenticationManager
 FileDownloaderManager
 AnalyticsManager

 Advantages:
    make it easy
    gives global access

 AntiDesign Pattern
    cannot have
    needs to be used carefully
    cannot write test cases
 */

import Foundation

class AuthenticationManager {

    static let shared = AuthenticationManager()
    private init() {}

    var isLoggedIn: Bool = false
    var authToken: String = ""

    func doLogin(token: String) {
        authToken = token
        isLoggedIn = true
    }

    func doLogount() {
        authToken = ""
        isLoggedIn = false
    }


}
