//
//  PaymentCardList.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2023/5/2.
//

import SwiftUI
import MyViewLibrary

struct PaymentCardList: View {
    @Binding var document: VirtualWalletDocument
    
    private var total: Int {
        document.primaryWallet.balance + document.secondaryWallet.reduce(0, { partialResult, wallet in
            partialResult + wallet.balance
        }) + document.otherWallet.reduce(0, { partialResult, wallet in
            partialResult + wallet.balance
        })
    }
    
    @State private var showTransferView = false
    
    var body: some View {
        List {
            Section {
                ForEach($document.paymentCards) { wallet in
                    RegularWalletRow(wallet: wallet)
                }
                .onMove { indexSet, newLocation in
                    document.paymentCards.move(fromOffsets: indexSet, toOffset: newLocation)
                }
                .onDelete { indexSet in
                    document.paymentCards.remove(atOffsets: indexSet)
                }
            }
        }
        .navigationTitle("付款卡")
        .toolbar {
            Button {
                document.secondaryWallet.append(Wallet(name: "新的次要钱包", transactions: []))
            } label: {
                Label("添加钱包", systemImage: "plus")
            }
        }
    }
}

struct PaymentCardList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PaymentCardList(document: .constant(VirtualWalletDocument()))
        }
    }
}
