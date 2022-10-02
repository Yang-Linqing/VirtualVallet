//
//  WalletView.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/3.
//

import SwiftUI

struct WalletView: View {
    @Binding var wallet: Wallet
    @State private var selection = Set<UUID>()
    @Environment(\.editMode) private var editMode
    
    var body: some View {
        List($wallet.transactions, editActions: [.all], selection: $selection) { transaction in
            TransactionRow(transaction: transaction, suggestions: wallet.transactionTypeSuggestions)
        }
        .navigationTitle($wallet.name)
        .toolbar {
            if editMode?.wrappedValue.isEditing == true {
                Button("完成") {
                    withAnimation {
                        editMode?.wrappedValue = .inactive
                    }
                }
                Menu {
                    Button(role: .destructive) {
                        withAnimation {
                            deleteSelected()
                        }
                    } label: {
                        Label("删除", systemImage: "xmark.bin")
                    }
                    .disabled(selection.isEmpty)
                    Button {
                        withAnimation {
                            squashSelected()
                        }
                    } label: {
                        Label("压缩", systemImage: "archivebox")
                    }
                    .disabled(selection.isEmpty)
                } label: {
                    CurrencyText(selectedTotal)
                }
            } else {
                Button {
                    withAnimation {
                        editMode?.wrappedValue = .active
                    }
                } label: {
                    Label("选择", systemImage: "checkmark.circle")
                }
                Button {
                    wallet.transactions.insert(Transaction(date: Date(), total: 0, type: ""), at: 0)
                } label: {
                    Label("添加交易", systemImage: "plus")
                }
                CurrencyText(wallet.balance)
            }
        }
    }
    
    var selectedTotal: Int {
        wallet.transactions.reduce(0) { partialResult, transaction in
            if selection.contains(transaction.id) {
                return partialResult + transaction.total
            } else {
                return partialResult
            }
        }
    }
    
    func deleteSelected() {
        var indexSet = IndexSet()
        for (i, transaction) in wallet.transactions.enumerated() {
            if selection.contains(transaction.id) {
                indexSet.insert(i)
            }
        }
        wallet.transactions.remove(atOffsets: indexSet)
    }
    
    func squashSelected() {
        let newTotal = selectedTotal
        let index = wallet.transactions.firstIndex { transaction in
            selection.contains(transaction.id)
        } ?? wallet.transactions.startIndex
        let newDate = wallet.transactions[index].date
        deleteSelected()
        wallet.transactions.insert(Transaction(date: newDate, total: newTotal, type: "压缩"), at: index)
    }
}

struct WalletView_Previews: PreviewProvider {
    @State static var wallet = Wallet.sampleSet.randomElement()!
    
    static var previews: some View {
        NavigationStack {
            WalletView(wallet: $wallet)
        }
    }
}
