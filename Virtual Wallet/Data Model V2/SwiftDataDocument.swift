//
//  SwiftDataDocument.swift
//  Virtual Wallet
//
//  Created by 杨林青 on 2023-10-29.
//

import SwiftData
import UniformTypeIdentifiers

struct VirtualWalletSchemaV2: VersionedSchema {
    static var versionIdentifier: Schema.Version = .init(2, 0, 0)
    static var models: [any PersistentModel.Type] = [Wallet.self, Transaction.self]
}

struct VirtualWalletSchemaMigrationPlan: SchemaMigrationPlan {
    static var schemas: [VersionedSchema.Type] = [VirtualWalletSchemaV2.self]
    static var stages: [MigrationStage] = []
}

extension UTType {
    static var virtualWallet = UTType(exportedAs: "cn.ylqdev.VirtualWalletDocument")
}
