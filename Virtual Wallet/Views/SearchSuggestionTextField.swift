//
//  SearchSuggestionTextField.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/9.
//

import SwiftUI

struct SearchSuggestionTextField: View {
    var label: String?
    @Binding var text: String
    var suggestions: [String]
    
    init(_ label: String?, text: Binding<String>, suggestions: [String]) {
        self.label = label
        self._text = text
        self.suggestions = suggestions
    }
    
    @State private var editingText = ""
    
    var body: some View {
        VStack {
            HStack {
                if label != nil {
                    Text(label!)
                    Spacer()
                }
                TextField("", text: $editingText)
                    .onSubmit {
                        text = editingText
                    }
                    .transformEnvironment(\.layoutDirection) { direction in
                        if label == nil {
                            return
                        } else if direction == .leftToRight {
                            direction = .rightToLeft
                            return
                        } else {
                            direction = .leftToRight
                            return
                        }
                    }
            }
            AnyLayout(FlowHStack()) {
                ForEach(suggestions, id: \.self) { suggest in
                    if suggest != "" {
                        if text == suggest {
                            Button(suggest) {
                                text = suggest
                                editingText = suggest
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.capsule)
                        } else {
                            Button(suggest) {
                                text = suggest
                                editingText = suggest
                            }
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            .tint(.primary)
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

struct SearchSuggestionTextPage: View {
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
        VStack {
            HStack {
                TextField("", text: $editingText)
                    .onSubmit {
                        text = editingText
                }
                Button {
                    text = ""
                    editingText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }.tint(.secondary)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background {
                Color(uiColor: .secondarySystemGroupedBackground)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .padding(.horizontal)
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(suggestions, id: \.self) { suggest in
                        if suggest != "" {
                            Button(suggest) {
                                text = suggest
                                editingText = suggest
                            }
                            .buttonStyle(.bordered)
                            .buttonBorderShape(.capsule)
                            .tint(.primary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 32.0)
            }
        }
        .background {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
        }
        .navigationTitle(label)
        .onAppear {
            editingText = text
        }
    }
}

struct SearchSuggestionTextField_Previews: PreviewProvider {
    @State private static var text = "麦当劳"
    @State private static var suggestions = ["struct", "PreviewProvider", "菜", "吃席", "KFC", "麦当劳", "紫菜蛋花汤", "滚蛋汤"]

    static var previews: some View {
        NavigationStack {
            Form {
                SearchSuggestionTextField("SearchText", text: $text, suggestions: suggestions)
            }
            .navigationTitle("Form")
            //SearchSuggestionTextPage("菜品", text: $text, suggestions: suggestions)
        }
    }
}
