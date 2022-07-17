//
//  TransferWizardView.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/16.
//

import SwiftUI

struct NewTransactionView: View {
    @Environment(\.document) private var document
    @Environment(\.dismiss) private var dismiss
    
    @State private var incomingWallet: Wallet?
    @State private var targetWallet: Wallet?
    @State private var date = Date()
    @State private var type = ""
    @State private var total = 0
        
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker(selection: $incomingWallet) {
                        SelectWalletView()
                    } label: {
                        Text("付款钱包")
                    }
                    .onAppear {
                        incomingWallet = document.primaryWallet.wrappedValue
                    }
                    Picker(selection: $targetWallet) {
                        SelectWalletView()
                    } label: {
                        Text("收款钱包")
                    }
                } header: {
                    HStack {
                        SectionTitle("钱包")
                        Spacer()
                        Button("交换") {
                            let temp = incomingWallet
                            incomingWallet = targetWallet
                            targetWallet = temp
                        }
                    }
                } footer: {
                    Text("要从钱包之间转账，请同时选择付款钱包和收款钱包。")
                }
                Section {
                    DatePicker(selection: $date, label: { Text("日期") })
                    HTextSuggestionView("类别", text: $type, suggestions: (incomingWallet?.transactionTypeSuggestions ?? []) + (targetWallet?.transactionTypeSuggestions ?? []))
                    PriceField(value: $total, positiveOnly: true) {
                        Text("总额")
                    }
                } header: {
                    SectionTitle("交易信息")
                }
            }
            .navigationTitle("记账")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        saveTransfer()
                    } label: {
                        Text("保存")
                    }
                    .disabled(incomingWallet == nil && targetWallet == nil)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("删除", role: .destructive) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func saveTransfer() {
        check(document.primaryWallet)
        document.secondaryWallet.forEach { wallet in
            check(wallet)
        }
        document.otherWallet.forEach { wallet in
            check(wallet)
        }
        
        dismiss()
    }
    
    func check(_ wallet: Binding<Wallet>) {
        if wallet.id == incomingWallet?.id {
            var outgoingTransaction = Transaction()
            outgoingTransaction.date = Date()
            outgoingTransaction.total = -abs(self.total)
            if self.type == "" {
                outgoingTransaction.type = "转至\(targetWallet?.name ?? "")"
            } else {
                outgoingTransaction.type = self.type
            }
            wallet.wrappedValue.transactions.insert(outgoingTransaction, at: 0)
        }
        if wallet.id == targetWallet?.id {
            var incomingTransaction = Transaction()
            incomingTransaction.date = Date()
            incomingTransaction.total = abs(self.total)
            if self.type == "" {
                incomingTransaction.type = "转自\(incomingWallet?.name ?? "")"
            } else {
                incomingTransaction.type = self.type
            }
            wallet.wrappedValue.transactions.insert(incomingTransaction, at: 0)
        }
    }
}

fileprivate struct SelectWalletView: View {
    @Environment(\.document)
    @Binding
    private var document: VirtualWalletDocument
    
    var body: some View {
        Text("选择一个钱包").tag(nil as Wallet?)
        Section {
            Text(document.primaryWallet.name).tag(document.primaryWallet as Wallet?)
        }
        Section {
            ForEach(document.secondaryWallet) { wallet in
                Text(wallet.name).tag(wallet as Wallet?)
            }
        }
        Section {
            ForEach(document.otherWallet) { wallet in
                Text(wallet.name).tag(wallet as Wallet?)
            }
        }
    }
}


struct TransferWizardView_Previews: PreviewProvider {
    @State private static var document = VirtualWalletDocument()
    
    static var previews: some View {
        NewTransactionView()
            .document($document)
    }
}
