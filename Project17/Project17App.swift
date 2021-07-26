//
//  Project17App.swift
//  Project17
//
//  Created by Evan Tu on 7/7/21.
//

import SwiftUI

@main
struct Project17App: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
