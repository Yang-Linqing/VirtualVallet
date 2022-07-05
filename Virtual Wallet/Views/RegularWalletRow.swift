//
//  RegularWalletRow.swift.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/3.
//

import SwiftUI

struct RegularWalletRow: View {
    @Binding var wallet: Wallet
    
    var body: some View {
        NavigationLink {
            WalletView(wallet: $wallet)
        } label: {
            HStack {
                Text(wallet.name)
                Spacer()
                Text(wallet.balance.currencyString)
            }
        }
    }
}

struct RegularWalletRow_Previews: PreviewProvider {
    @State static var wallet = Wallet(name: "其他", transactions: [])
    
    static var previews: some View {
        NavigationStack {
            RegularWalletRow(wallet: $wallet)
        }
        .previewLayout(.fixed(width: 400, height: 40))
    }
}
