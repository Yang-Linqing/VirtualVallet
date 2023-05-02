//
//  ContentView.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/3.
//

import SwiftUI

struct Home: View {
    @Binding var document: VirtualWalletDocument

    var body: some View {
        TabView {
            WalletList(document: $document)
                .tabItem { Label("虚拟钱包", systemImage: "mail") }
            PaymentCardList(document: $document)
                .tabItem { Label("付款卡", systemImage: "creditcard") }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            Home(document: .constant(VirtualWalletDocument()))
                .navigationTitle("Filename")
        }
    }
}
