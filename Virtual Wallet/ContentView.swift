//
//  ContentView.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/3.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: VirtualWalletDocument
    
    private var total: Int {
        document.primaryWallet.balance + document.secondaryWallet.reduce(0, { partialResult, wallet in
            partialResult + wallet.balance
        }) + document.otherWallet.reduce(0, { partialResult, wallet in
            partialResult + wallet.balance
        })
    }

    var body: some View {
        List {
            Section {
                PrimaryWalletView(wallet: $document.primaryWallet)
            } header: {
                Text("主要")
                    .font(.headline)
            }
            Section {
                ForEach($document.secondaryWallet) { wallet in
                    RegularWalletRow(wallet: wallet)
                }
                .onMove { indexSet, newLocation in
                    document.secondaryWallet.move(fromOffsets: indexSet, toOffset: newLocation)
                }
                .onDelete { indexSet in
                    document.secondaryWallet.remove(atOffsets: indexSet)
                }
            } header: {
                HStack {
                    Text("次要")
                        .font(.headline)
                    Spacer()
                    Button {
                        document.secondaryWallet.append(Wallet(name: "新的次要钱包", transactions: []))
                    } label: {
                        Label("添加钱包", systemImage: "plus")
                    }

                }
            }
            Section {
                ForEach($document.otherWallet) { wallet in
                    RegularWalletRow(wallet: wallet)
                }
                .onMove { indexSet, newLocation in
                    document.otherWallet.move(fromOffsets: indexSet, toOffset: newLocation)
                }
                .onDelete { indexSet in
                    document.otherWallet.remove(atOffsets: indexSet)
                }
            } header: {
                HStack {
                    Text("其他")
                        .font(.headline)
                    Spacer()
                    Button {
                        document.otherWallet.append(Wallet(name: "新的其他钱包", transactions: []))
                    } label: {
                        Label("添加钱包", systemImage: "plus")
                    }

                }
            }
        }
        .toolbar {
            CurrencyText(total)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView(document: .constant(VirtualWalletDocument()))
        }
    }
}
