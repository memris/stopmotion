//
//  Mode.swift
//  stopmotion
//
//  Created by USER on 01.11.2024.
//

import SwiftUI

enum Mode {
    case draw
    case erase
    init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .draw
        case 1: self = .erase
        default: return nil
        }
    }
}
