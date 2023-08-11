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
            HStack{
                Button("Translate") {
                    isNeedTranslate.toggle()
                }
                .padding(.leading, 20)
                
                Spacer()
                
                Button("Next") {
                    word = group.items.randomElement() ?? Word()
                    isNeedTranslate = false
                }
                .padding(.trailing, 20)
            }

        }
    }
}

