//
//  Item.swift
//  SeninAnonym
//
//  Created by Ardahan Kul on 3.09.2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
