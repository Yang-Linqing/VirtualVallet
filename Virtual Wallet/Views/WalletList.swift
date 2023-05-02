//
//  WalletList.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2023/5/2.
//

import SwiftUI
import MyViewLibrary

struct WalletList: View {
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
                PrimaryWalletView(wallet: $document.primaryWallet)
                HStack() {
                    VStack(alignment: .leading) {
                        Text("所有钱包")
                            .font(.headline)
                        CurrencyText(total)
                    }
                    Spacer()
                    Button {
                        showTransferView = true
                    } label: {
                        Image(systemName: "arrow.left.arrow.right")
                        Text("记账")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.primary)
                    .sheet(isPresented: $showTransferView) {
                        NewTransactionSheet()
                            .document($document)
                    }
                }
                .buttonStyle(.plain)
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
    }
}

struct WalletList_Previews: PreviewProvider {
    static var previews: some View {
        WalletList(document: .constant(VirtualWalletDocument()))
    }
}
