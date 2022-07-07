//
//  PrimaryWalletView.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/3.
//

import SwiftUI

struct PrimaryWalletView: View {
    @Binding var wallet: Wallet
    
    var body: some View {
        NavigationLink {
            WalletView(wallet: $wallet)
        } label: {
            VStack(alignment: .leading) {
                Text(wallet.name)
                    .font(.headline)
                CurrencyText(wallet.balance, textStyle: .largeTitle)
                    .fontWeight(.bold)
            }
        }
    }
}

struct PrimaryWalletView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            List {
                PrimaryWalletView(wallet: .constant(Wallet(name: "每日饮食", transactions: [])))
            }
        }
    }
}
