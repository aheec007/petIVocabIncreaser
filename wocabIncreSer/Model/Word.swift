//
//  word.swift
//  wocabIncreSer
//
//  Created by alex on 08.08.2023.
//

import Foundation
import RealmSwift
import SwiftUI

/// Random adjectives for more interesting demo item names
let randomAdjectives = [
    "fluffy", "classy", "bumpy", "bizarre", "wiggly", "quick", "sudden",
    "acoustic", "smiling", "dispensable", "foreign", "shaky", "purple", "keen",
    "aberrant", "disastrous", "vague", "squealing", "ad hoc", "sweet"
]
/// Random noun for more interesting demo item names
let randomNouns = [
    "floor", "monitor", "hair tie", "puddle", "hair brush", "bread",
    "cinder block", "glass", "ring", "twister", "coasters", "fridge",
    "toe ring", "bracelet", "cabinet", "nail file", "plate", "lace",
    "cork", "mouse pad"
]

enum RareType: Int {
    case often = 0
    case normal
    case rare
    
    var color: Color {
        switch self {
        case .often: return .green
        case .normal: return .yellow
        case .rare: return .red
        }
    }
}

/// An individual item. Part of an `ItemGroup`.
final class Word: Object, ObjectKeyIdentifiable {
    /// The unique ID of the Item. `primaryKey: true` declares the
    /// _id member as the primary key to the realm.
    @Persisted(primaryKey: true) var _id: ObjectId
    /// The name of the Item, By default, a random name is generated.
    
    /// A flag indicating whether the user "favorited" the item.
    @Persisted var isFavorite = false
    /// Users can enter a description, which is an empty string by default
    @Persisted var itemDescription = ""
    
    /// The backlink to the `ItemGroup` this item is a part of.
    @Persisted(originProperty: "items") var group: LinkingObjects<ItemGroup>
    
    /// Store the user.id as the ownerId so you can query for the user's objects with Flexible Sync
    /// Add this to both the `ItemGroup` and the `Item` objects so you can read and write the linked objects.
    @Persisted var ownerId = ""
    
    @Persisted var rusValue: String = "Какое-то слово"
    @Persisted var engValue: String = "Some word"
    
    @Persisted var rareTypeValue: Int = RareType.normal.rawValue
    var rareType: RareType {
        get {
            RareType(rawValue: rareTypeValue) ?? .normal
        }
        set {
            rareTypeValue = newValue.rawValue
        }
    }
    
    var name: String {
        "\(rusValue) -> \(engValue)"
    }
}
