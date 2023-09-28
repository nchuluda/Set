//
//  SetApp.swift
//  Set
//
//  Created by Nathan on 9/13/23.
//

import SwiftUI

@main
struct SetApp: App {
    @StateObject var game = Set()
    var body: some Scene {
        WindowGroup {
            SetView(viewModel: game)
        }
    }
}
