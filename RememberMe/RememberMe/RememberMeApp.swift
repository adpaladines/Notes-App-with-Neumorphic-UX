//
//  RememberMeApp.swift
//  RememberMe
//
//  Created by Andres D. Paladines on 7/28/23.
//

import SwiftUI

@main
struct RememberMeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ContentViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
