//Created by IPH Technologies Pvt. Ltd.

import Foundation

import UIKit

enum Color: String {
    case red = "Red"
    case black = "Black"
    case green = "Green"
    case empty
}

struct Sector: Equatable {
    let number: Int
    let color: Color
}

