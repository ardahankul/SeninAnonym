//
//  SeninAnonymApp.swift
//  SeninAnonym
//
//  Created by Ardahan Kul on 3.09.2023.
//

import SwiftUI
import SwiftData

@main
struct SeninAnonymApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
