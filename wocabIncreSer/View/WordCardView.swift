//
//  WordCardView.swift
//  wocabIncreSer
//
//  Created by alex on 09.08.2023.
//

import SwiftUI

struct WordCardView: View {
    
    var group: ItemGroup
    
    @State private var word: Word
    @State private var isNeedTranslate: Bool = false
    
    init(group: ItemGroup) {
        self.group = group
        
        self._word = State(initialValue: group.items.randomElement() ?? Word())
    }
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                Text(word.engValue)
                    
                Rectangle()
                    .fill(word.rareType.color)
                    .cornerRadius(6)
                    .frame(width: 15, height: 15)
            }
            .padding(.bottom, 10)
            
            if isNeedTranslate {
                Text(word.rusValue)
            }
            Spacer()
            Text("\(word.showTranslateCount) / \(word.appearancesConut)")
            
            Spacer()
                
            Button(action: {
                isNeedTranslate.toggle()
                word.save { $0.showTranslateCount = $0.showTranslateCount + 1 }
            }) {
                Text("Translate")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(.white)
           }
           .overlay(
              RoundedRectangle(cornerRadius: 12)
                   .stroke(Color.black, lineWidth: 1)
                   .frame(minHeight: 46, maxHeight: 47)
           )
           .frame(minHeight: 46, maxHeight: 46)
           .background(Color.red)
           .cornerRadius(12)
            
            Button(action: {
                word = group.items.randomElement() ?? Word()
                word.save {
                    $0.appearancesConut = $0.appearancesConut + 1
                    $0.lastChangeDade = Date.now
                }
                isNeedTranslate = false
            }) {
                Text("Next")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(.white)
            }
            .overlay(
               RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black, lineWidth: 1)
                    .frame(minHeight: 46, maxHeight: 47)
            )
            .frame(minHeight: 46, maxHeight: 46)
            .background(Color.green)
            .cornerRadius(12)

        }
        .padding()
    }
}

