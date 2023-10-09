//
//  ContentView.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/3.
//

import SwiftUI
import MyViewLibrary

struct Home: View {
    @EnvironmentObject private var store: VirtualWalletStore
    @Environment(\.undoManager) private var undoManager
    
    @State private var showTransferView = false

    var body: some View {
        List {
            Section {
                PrimaryWalletView(wallet: $store.document.primaryWallet)
                HStack() {
                    VStack(alignment: .leading) {
                        Text("所有钱包")
                            .font(.headline)
                        Text(store.total, format: .currency(code: Locale.current.currency?.identifier ?? "CNY"))
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
                    }
                }
                .buttonStyle(.plain)
            }
            Section {
                ForEach($store.document.secondaryWallet) { wallet in
                    RegularWalletRow(wallet: wallet)
                }
                .onMove { indexSet, newLocation in
                    store.document.secondaryWallet.move(fromOffsets: indexSet, toOffset: newLocation)
                }
                .onDelete { indexSet in
                    store.document.secondaryWallet.remove(atOffsets: indexSet)
                }
            } header: {
                HStack {
                    Text("次要")
                        .font(.headline)
                    Spacer()
                    Button {
                        store.document.secondaryWallet.append(Wallet(name: "新的次要钱包", transactions: []))
                    } label: {
                        Label("添加钱包", systemImage: "plus")
                    }

                }
            }
            Section {
                ForEach($store.document.otherWallet) { wallet in
                    RegularWalletRow(wallet: wallet)
                }
                .onMove { indexSet, newLocation in
                    store.document.otherWallet.move(fromOffsets: indexSet, toOffset: newLocation)
                }
                .onDelete { indexSet in
                    store.document.otherWallet.remove(atOffsets: indexSet)
                }
            } header: {
                HStack {
                    Text("其他")
                        .font(.headline)
                    Spacer()
                    Button {
                        store.document.otherWallet.append(Wallet(name: "新的其他钱包", transactions: []))
                    } label: {
                        Label("添加钱包", systemImage: "plus")
                    }

                }
            }
        }
        .onAppear {
            store.undoManager = undoManager
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            Home()
        }
        .environmentObject(VirtualWalletStore())
    }
}
