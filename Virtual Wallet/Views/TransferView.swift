//
//  TransferWizardView.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/16.
//

import SwiftUI

struct TransferView: View {
    @Environment(\.document) private var document
    @Environment(\.dismiss) private var dismiss
    
    @State private var incomingWallet: Wallet?
    @State private var targetWallet: Wallet?
    @State private var date = Date()
    @State private var total = 0
        
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker(selection: $incomingWallet) {
                        SelectWalletView()
                    } label: {
                        Text("转自")
                    }
                    Picker(selection: $targetWallet) {
                        SelectWalletView()
                    } label: {
                        Text("转至")
                    }
                    DatePicker(selection: $date, label: { Text("日期") })
                    PriceField(value: $total) {
                        Text("总额")
                    }
                }
                Section {
                    Button {
                        saveTransfer()
                    } label: {
                        Text("保存")
                            .frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 0))
                    .disabled(incomingWallet == nil || targetWallet == nil)
                    .listRowInsets(EdgeInsets())
                }
            }
            .navigationTitle("转账")
        }
    }
    
    func saveTransfer() {
        guard incomingWallet != nil && targetWallet != nil else {
            return
        }

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
            let outgoingTransaction = Transaction(date: self.date, total: -abs(self.total), type: "转至\(targetWallet!.name)")
            wallet.wrappedValue.transactions.insert(outgoingTransaction, at: 0)
        }
        if wallet.id == targetWallet?.id {
            let incomingTransaction = Transaction(date: self.date, total: abs(self.total), type: "转自\(incomingWallet!.name)")
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
        TransferView()
            .document($document)
    }
}
