//
//  Virtual_WalletApp.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/3.
//

import SwiftUI

@main
struct VirtualWalletApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: VirtualWalletDocument()) { file in
            Home(document: file.$document)
        }
    }
}
