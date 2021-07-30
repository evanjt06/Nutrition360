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
                .onAppear {
                    let defaults = UserDefaults.standard
                    
                    print(
                        defaults.bool(forKey: "showingIntroPopUp"),
                        defaults.bool(forKey: "hasSeenOnboarding"),
                        defaults.string(forKey: "name"),
                        defaults.string(forKey: "gender")
                    )
                }
        }
    }
}
