//
//  WalletView.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/3.
//

import SwiftUI

struct WalletView: View {
    @Binding var wallet: Wallet
    
    var body: some View {
        List {
            ForEach($wallet.transactions) { transaction in
                TransactionRow(transaction: transaction)
            }
            .onMove { indexSet, newLocation in
                wallet.transactions.move(fromOffsets: indexSet, toOffset: newLocation)
            }
            .onDelete { indexSet in
                wallet.transactions.remove(atOffsets: indexSet)
            }
        }
        .navigationTitle($wallet.name)
        .toolbar {
            CurrencyText(wallet.balance)
            Button {
                wallet.transactions.insert(Transaction(date: Date(), total: 0, type: ""), at: 0)
            } label: {
                Label("添加交易", systemImage: "plus")
            }
        }
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
