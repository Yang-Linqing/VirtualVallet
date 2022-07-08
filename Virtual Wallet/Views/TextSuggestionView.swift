//
//  TextSuggestionView.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/8.
//

import SwiftUI

struct TextSuggestionView: View {
    @Binding var text: String
    var suggestions: [String]
    
    @FocusState private var isEditing: Bool
    @State private var editingText = ""
    
    var body: some View {
        VStack {
            TextField("", text: $editingText)
                .focused($isEditing)
                .onSubmit {
                    text = editingText
                }
            if isEditing {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(suggestions, id: \.self) { suggestion in
                            if text == suggestion {
                                Button(suggestion) {
                                    text = suggestion
                                    editingText = suggestion
                                }
                                .buttonStyle(.borderedProminent)
                                .buttonBorderShape(.capsule)
                            } else {
                                Button(suggestion) {
                                    text = suggestion
                                    editingText = suggestion
                                }
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.capsule)
                                .tint(.primary)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            editingText = text
        }
    }
}

struct TextSuggestionView_Previews: PreviewProvider {
    @State private static var text = ""
    @State private static var suggestions = ["struct", "PreviewProvider", "菜", "吃席", "KFC", "麦当劳", "紫菜蛋花汤", "滚蛋汤"]
    static var previews: some View {
        Form {
            TextSuggestionView(text: $text, suggestions: suggestions)
        }
    }
}
