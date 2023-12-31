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
    @State private var rareType: RareType = .normal
    
    init(_ group: ItemGroup, word: Word?) {
        self.group = group
        self.word = word
        
        self._rusName = State(initialValue: word?.rusValue ?? "")
        self._engName = State(initialValue: word?.engValue ?? "")
        self._rareType = State(initialValue: word?.rareType ?? .normal)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Введите слова на русском:")
                    .foregroundColor(.gray)
                Spacer()
                Rectangle()
                    .fill(rareType.color)
                    .cornerRadius(6)
                    .frame(width: 30, height: 30)
            }
            .navigationBarTitle("Edit word", displayMode: .inline)
                
            // Accept a new name
            TextField("New name", text:  $rusName)
            
            Text("Введите перевод")
                .foregroundColor(.gray)
            TextField("New translate", text: $engName)
            
            HStack(alignment: .center) {
                Button(){
                    rareType = .often
                } label: {
                    Rectangle()
                        .fill(.green)
                        .cornerRadius(6)
                        .frame(width: 30, height: 30)
                }
                
                Button(){
                    rareType = .normal
                } label: {
                    Rectangle()
                        .fill(.yellow)
                        .cornerRadius(6)
                        .frame(width: 30, height: 30)
                }
                
                Button(){
                    rareType = .rare
                } label: {
                    Rectangle()
                        .fill(.red)
                        .cornerRadius(6)
                        .frame(width: 30, height: 30)
                }
                
            }
            .padding(.top, 10)
            
            GeometryReader { geometry in
                Button(action: {
                    if let word = word {
                        word.save {
                            $0.rusValue = rusName
                            $0.engValue = engName
                            $0.rareType = rareType
                            $0.createDate = Date()
                        }
                    } else {
                        group.save {
                            let word = Word()
                            word.rusValue = rusName
                            word.engValue = engName
                            word.rareType = rareType
                            word.lastChangeDade = Date()
                            $0.items.append(word)
                        }
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                }){
                    Text("Save")
                        .frame(
                            minWidth: (geometry.size.width / 2) - 25,
                            maxWidth: .infinity, minHeight: 44
                        )
                        .font(Font.subheadline.weight(.bold))
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding(.top, 30)
            
            Spacer()
        }.padding()
    }
}
