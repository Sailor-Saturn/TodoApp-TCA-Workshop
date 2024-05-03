//
//  TODOProjectWorkshopApp.swift
//  TODOProjectWorkshop
//
//  Created by Vera Dias on 03/05/2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct TODOProjectWorkshopApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
              store: Store(initialState: Todos.State(todos: .mock)) {
                Todos()
              }
            )
        }
    }
}
