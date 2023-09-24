//
//  SetApp.swift
//  Set
//
//  Created by Nathan on 9/13/23.
//

import SwiftUI

@main
struct SetApp: App {
    var game = Set()
    var body: some Scene {
        WindowGroup {
            SetView(viewModel: game)
        }
    }
}
