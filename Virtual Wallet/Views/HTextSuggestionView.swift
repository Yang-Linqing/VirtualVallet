//
//  TextSuggestionView.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/8.
//

import SwiftUI

struct HTextSuggestionView: View {
    var label: String
    @Binding var text: String
    var suggestions: [String]
    
    init(_ label: String, text: Binding<String>, suggestions: [String]) {
        self.label = label
        self._text = text
        self.suggestions = suggestions
    }
    
    @State private var editingText = ""
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            TextField("", text: $editingText)
                .onSubmit {
                    text = editingText
                }
                .transformEnvironment(\.layoutDirection) { direction in
                    if direction == .leftToRight {
                        direction = .rightToLeft
                    } else {
                        direction = .leftToRight
                    }
                }
        }
        .onAppear {
            editingText = text
        }
        HStack {
            Text("建议")
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
}

struct HTextSuggestionView_Previews: PreviewProvider {
    @State private static var text = ""
    @State private static var suggestions = ["struct", "PreviewProvider", "菜", "吃席", "KFC", "麦当劳", "紫菜蛋花汤", "滚蛋汤"]
    static var previews: some View {
        Form {
            HTextSuggestionView("Label", text: $text, suggestions: suggestions)
        }
    }
}
