//
//  MinAppApp.swift
//  MinApp
//
//  Created by Rebecca Zadig on 2022-11-17.
//

import SwiftUI

@main
struct MinAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
