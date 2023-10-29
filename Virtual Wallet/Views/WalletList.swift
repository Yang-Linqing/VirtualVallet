//
//  WalletList.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2023-10-29.
//

import SwiftUI
import SwiftData

struct WalletList: View {
    @Query private var wallets: [Wallet]
    
    var body: some View {
        List(wallets) { wallet in
            Text(wallet.name)
        }
    }
}

#Preview {
    WalletList()
        .modelContainer(previewContainer)
}
