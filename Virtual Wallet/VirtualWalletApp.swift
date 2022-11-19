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
            NavigationSplitView(columnVisibility: .constant(.doubleColumn)) {
                Home(document: file.$document)
                    .listStyle(.insetGrouped)
                    .navigationTitle(file.fileURL?.deletingPathExtension().lastPathComponent ?? "")
            } detail: {
                EmptyView()
            }
            .toolbar(.hidden)
        }
    }
}
