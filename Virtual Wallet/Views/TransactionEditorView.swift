//
//  TransactionEditorView.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/3.
//

import SwiftUI

struct TransactionEditorView: View {
    @Binding var transaction: Transaction
    var suggestions: [String] = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker(selection: $transaction.date, label: { Text("时间") })
                    TextSuggestionView(text: $transaction.type, suggestions: suggestions)
                    PriceField(value: $transaction.total) {
                        Text("金额")
                    }
                }
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 8.0) {
                            Text("下划保存并关闭")
                            Image(systemName: "chevron.compact.down")
                                .imageScale(.large)
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }
                .foregroundStyle(.secondary)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("编辑交易")
        }
    }
}

fileprivate let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
}()

struct TransactionRow: View {
    @Binding var transaction: Transaction
    var suggestions: [String] = []
    
    @State private var isPresented = false
    
    var body: some View {
        Button {
            isPresented = true
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(transaction.date, formatter: dateFormatter)")
                    Text(transaction.type)
                }
                Spacer()
                Text(transaction.total.currencyString)
            }
            .foregroundColor(.primary)
        }
        .sheet(isPresented: $isPresented) {
            TransactionEditorView(transaction: $transaction, suggestions: suggestions)
        }
    }
}

struct TransactionEditorView_Previews: PreviewProvider {
    @State static var transaction = Transaction(date: Date(), total: 1245, type: "KFC")
    
    static var previews: some View {
        TransactionEditorView(transaction: $transaction)
    }
}
