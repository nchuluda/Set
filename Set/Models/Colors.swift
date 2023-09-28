//
//  Colors.swift
//  Set
//
//  Created by Nathan on 9/26/23.
//

import Foundation
import SwiftUI

enum Colors: CaseIterable {
    case red
    case purple
    case green
    var rawValue: Color {
        switch self {
        case .red:
            return .red
        case .purple:
            return .purple
        case .green:
            return .green
        }
    }
}
