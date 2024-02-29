//
//  SharedStateApp.swift
//  SharedState
//
//  Created by David Whetstone on 2/28/24.
//

import SwiftUI

@main
struct SharedStateApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: .init(initialState: .init()) {
                ContentReducer()
            })
        }
    }
}
