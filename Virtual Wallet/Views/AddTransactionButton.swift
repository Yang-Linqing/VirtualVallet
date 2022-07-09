//
//  AddTransactionButton.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/7.
//

import SwiftUI

struct AddTransactionButton: View {
    @Binding var document: VirtualWalletDocument
    
    @State private var shouldPresentEditor = false
    
    var body: some View {
        VStack {
            Button {
                document.primaryWallet.transactions.insert(Transaction(), at: 0)
                shouldPresentEditor = true
            } label: {
                HStack {
                    Image(systemName: "pencil.line")
                    Text("记账")
                }
                .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            }
            .buttonStyle(.borderedProminent)
            .tint(.primary)
            .sheet(isPresented: $shouldPresentEditor) {
                TransactionEditorView(transaction: $document.primaryWallet.transactions.first!, suggestions: document.primaryWallet.transactionTypeSuggestions)
            }
        }
    }
}

struct AddTransactionButton_Previews: PreviewProvider {
    @State static var document = VirtualWalletDocument()
    
    static var previews: some View {
        AddTransactionButton(document: $document)
    }
}
