//
//  WalletView.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/3.
//

import SwiftUI
import MyViewLibrary

struct WalletView: View {
    @Binding var wallet: Wallet
    @State private var selection = Set<UUID>()
    @Environment(\.editMode) private var editMode
    @State private var showSquashSheet = false
    
    var body: some View {
        List(selection: $selection) {
            ForEach(wallet.transactions.grouped()) { group in
                Section {
                    ForEach(group.transactions) { transaction in
                        TransactionRow(transaction: $wallet[transaction.id], suggestions: wallet.transactionTypeSuggestions)
                            .swipeActions {
                                Button("删除", role: .destructive) {
                                    wallet.deleteTransactions([transaction.id])
                                }
                            }
                    }
                } header: {
                    SectionTitle(group.title)
                }
            }
        }
        .navigationTitle($wallet.name)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                if editMode?.wrappedValue.isEditing == true {
                    Button(role: .destructive, action: deleteSelected) {
                        Label("删除", systemImage: "xmark.bin")
                            .labelStyle(.titleAndIcon)
                    }
                    .tint(.red)
                    .disabled(selection.isEmpty)
                    Button {
                        showSquashSheet = true
                    } label: {
                        Label("压缩", systemImage: "archivebox")
                            .labelStyle(.titleAndIcon)
                    }
                    .confirmationDialog("如何压缩选择的交易？", isPresented: $showSquashSheet, titleVisibility: .visible) {
                        Button("合并同类项", action: squashSelectedByType)
                        Button("压缩为一个", action: squashSelected)
                    }
                    .disabled(selection.isEmpty)
                } else {
                    Button {
                        wallet.transactions.insert(Transaction(date: Date(), total: 0, type: ""), at: 0)
                    } label: {
                        Label("添加交易", systemImage: "plus.circle.fill")
                            .labelStyle(.titleAndIcon)
                    }
                }
            }
            ToolbarItemGroup(placement: .status) {
                if editMode?.wrappedValue.isEditing == true {
                    CurrencyText(selectedTotal)
                } else {
                    CurrencyText(wallet.balance)
                }
            }
            ToolbarItemGroup {
                if editMode?.wrappedValue.isEditing == true {
                    Button("完成") {
                        withAnimation {
                            editMode?.wrappedValue = .inactive
                        }
                    }
                } else {
                    Button {
                        withAnimation {
                            editMode?.wrappedValue = .active
                        }
                    } label: {
                        Label("选择", systemImage: "checkmark.circle")
                            .labelStyle(.titleAndIcon)
                    }
                    
                }
            }
        }
        .animation(.default, value: wallet)
        .animation(.default, value: editMode?.wrappedValue)
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
        wallet.deleteTransactions(selection)
    }
    
    func squashSelected() {
        wallet.squashTransactions(selection)
    }
    
    func squashSelectedByType() {
        wallet.squashTransactionsByType(selection)
    }
}

fileprivate let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()

struct WalletView_Previews: PreviewProvider {
    @State static var wallet = Wallet.sampleSet.randomElement()!
    
    static var previews: some View {
        NavigationStack {
            WalletView(wallet: $wallet)
        }
    }
}
