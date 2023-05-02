//
//  PaymentCardList.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2023/5/2.
//

import SwiftUI

struct PaymentCardList: View {
    @Binding var document: VirtualWalletDocument
    
    var body: some View {
        List(document.paymentCards) { paymentcard in
            Text(paymentcard.name)
            //RegularWalletRow(wallet: paymentcard)
        }
    }
}

struct PaymentCardList_Previews: PreviewProvider {
    static var previews: some View {
        PaymentCardList(document: .constant(VirtualWalletDocument()))
    }
}
