//
//  Counts.swift
//  Set
//
//  Created by Nathan on 9/26/23.
//

import Foundation

enum Counts: Int, CaseIterable {
    case one
    case two
    case three
    var rawValue: Int {
        switch self {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        }
    }
}
