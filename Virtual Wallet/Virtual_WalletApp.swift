//
//  Virtual_WalletApp.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2022/7/3.
//

import SwiftUI

@main
struct Virtual_WalletApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: Virtual_WalletDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
