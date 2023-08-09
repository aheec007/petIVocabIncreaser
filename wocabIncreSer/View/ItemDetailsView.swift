//
//  ItemDetailsView.swift
//  wocabIncreSer
//
//  Created by alex on 09.08.2023.
//

import SwiftUI
import RealmSwift

/// Represents a screen where you can edit the item's name.
struct ItemDetailsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var group: ItemGroup
    var word: Word?
    
    @State private var rusName: String = ""
    @State private var engName: String = ""
    
    init(_ group: ItemGroup, word: Word?) {
        self.group = group
        self.word = word
        
        self._rusName = State(initialValue: word?.rusValue ?? "")
        self._engName = State(initialValue: word?.engValue ?? "")

    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Введите слова на русском:")
                .foregroundColor(.gray)
            // Accept a new name
            TextField("New name", text:  $rusName)
            
            Text("Введите перевод")
                .foregroundColor(.gray)
            TextField("New translate", text: $engName)
            Spacer()
            
            
            Button("Готово") {
                if let word = word {
                    let id = word._id
                    if let realm = try? Realm(), let selfItem = realm.object(ofType: Word.self, forPrimaryKey: id) {
                        
                        do {
                            try realm.write({
                                selfItem.rusValue = rusName
                                selfItem.engValue = engName
                            })
                            
                        } catch {
                            print(error)
                        }
                    }
                    
                } else {
                    let id = group._id
                    if let realm = try? Realm(), let selfItem = realm.object(ofType: ItemGroup.self, forPrimaryKey: id) {
                        
                        do {
                            try realm.write({
                                let word = Word()
                                word.rusValue = rusName
                                word.engValue = engName
                                selfItem.items.append(word)
                            })
                            
                        } catch {
                            print(error)
                        }
                        
                    }
                }
                
                presentationMode.wrappedValue.dismiss()
            }
            
        }.padding()
    }
}
