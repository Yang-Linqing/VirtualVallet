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
        DocumentGroup(newDocument: { VirtualWalletStore() }) { configuration in
            NavigationSplitView(columnVisibility: .constant(.doubleColumn)) {
                Home()
                    .navigationTitle(configuration.fileURL?.deletingPathExtension().lastPathComponent ?? "")
            } detail: {
                EmptyView()
            }
        }
    }
}
