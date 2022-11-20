//
//  TransactionEditorView.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/3.
//

import SwiftUI
import MyViewLibrary

struct TransactionEditorView: View {
    @Binding var transaction: Transaction
    var suggestions: [String] = []
    
    var body: some View {
        Form {
            Section {
                DatePicker(selection: $transaction.date, label: { Text("时间") })
            }
            Section {
                SearchSuggestionTextField("类别", text: $transaction.type, suggestions: suggestions)
            }
            Section {
                PriceField(value: $transaction.total) {
                    Text("金额")
                }
            } footer: {
                HStack {
                    Spacer()
                    VStack(spacing: 8.0) {
                        Text("下划保存并关闭")
                        Image(systemName: "chevron.compact.down")
                            .imageScale(.large)
                    }
                    Spacer()
                }
                .font(.body)
            }
        }
        .listStyle(.insetGrouped)
    }
}

fileprivate let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
}()

struct TransactionRowContent: View {
    var transaction: Transaction
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(transaction.type)
                    .fontWeight(.bold)
                Spacer()
                CurrencyText(transaction.total)
            }
            Text("\(transaction.date, formatter: dateFormatter)")
                .foregroundColor(.secondary)
        }
    }
}

struct TransactionRow: View {
    @Binding var transaction: Transaction
    @Environment(\.editMode) private var editMode
    var suggestions: [String] = []
    
    @State private var isPresented = false
    
    var body: some View {
        if editMode?.wrappedValue.isEditing == true {
            TransactionRowContent(transaction: transaction)
        } else {
            Button {
                isPresented = true
            } label: {
                TransactionRowContent(transaction: transaction)
                .foregroundColor(.primary)
            }
            .sheet(isPresented: $isPresented) {
                TransactionEditorView(transaction: $transaction, suggestions: suggestions)
            }
        }
    }
}

struct TransactionEditorView_Previews: PreviewProvider {
    @State static var transaction = Transaction(date: Date(), total: 1245, type: "KFC")
    
    static var previews: some View {
        TransactionEditorView(transaction: $transaction)
    }
}
